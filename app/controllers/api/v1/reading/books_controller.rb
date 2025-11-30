module Api
  module V1
    module Reading
      class BooksController < ApplicationController
        include Localizable
        before_action :authenticate_user!, except: [ :index, :show ]
        before_action :set_book, only: [ :show, :update, :destroy ]

        def index
          books = if current_user
                    current_user.books
          else
                    Book.all
          end
          books = books.where(status: params[:status]) if params[:status].present?
          render json: { data: books.recent.map { |book| book_response(book) } }, status: :ok
        end

        def show
          render json: { data: book_response(@book) }, status: :ok
        end

        def create
          book = current_user.books.new(book_params)
          if book.save
            save_translations(book)
            render json: { message: "Book added", book: book_response(book) }, status: :created
          else
            render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @book.update(book_params)
            save_translations(@book)
            render json: { message: "Book updated", book: book_response(@book) }, status: :ok
          else
            render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @book.destroy
          render json: { message: "Book deleted" }, status: :ok
        end

        private

        def set_book
          @book = current_user.books.find(params[:id])
        end

        def book_params
          params.permit(
            :title,
            :author,
            :publisher,
            :status,
            :start_date,
            :end_date,
            :rating,
            :review,
            :cover_image,
            :pages,
            categories: []
          )
        end

        def save_translations(book)
          return unless params[:translations].present?
          
          %w[ko ja].each do |locale|
            if params[:translations][locale].present?
              book.set_translations(locale, params[:translations][locale].permit(:title, :author, :review).to_h)
            end
          end
        end

        def book_response(book)
          ko_translations = book.translations_for('ko')
          ja_translations = book.translations_for('ja')
          
          translations_for_locale = case current_locale
                                    when 'ko' then ko_translations
                                    when 'ja' then ja_translations
                                    else {}
                                    end
          
          title = translations_for_locale['title'].presence || book.title
          author = translations_for_locale['author'].presence || book.author
          review = translations_for_locale['review'].presence || book.review

          {
            id: book.id.to_s,
            title: title,
            author: author,
            publisher: book.publisher,
            status: book.status,
            startDate: book.start_date,
            endDate: book.end_date,
            rating: book.rating,
            review: review,
            coverImage: book.cover_image,
            category: book.categories || [],
            pages: book.pages,
            translations: {
              ko: ko_translations,
              ja: ja_translations
            }
          }
        end
      end
    end
  end
end
