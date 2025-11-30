# Create main user - 방세준
user = User.find_or_create_by!(email: "noah8.technologies@proton.me") do |u|
  u.name = "방세준"
  u.tagline = "배움을 멈추지 않는 개발자"
  u.bio = "안녕하세요, 저는 배움을 멈추지 않는 개발자 방세준입니다. 저는 DevOps 엔지니어가 되어 복잡한 소프트웨어를 효율적으로 관리하는 것을 목표로 합니다. 최근, 소프트웨어는 더욱 더 복잡해지고 있고, 소프트웨어 아키텍처의 중요성 또한 커지고 있습니다."
  u.phone = "010-6366-5783"
  u.github_url = "https://github.com/yuuki08noah"
  u.role = "admin"
  u.job_position = "DevOps Engineer"
  u.password = SecureRandom.hex(32)
  u.email_verified = true
end

puts "Created user: #{user.name}"

# Create main projects
projects_data = [
  {
    title: "최애의 사인(死因)",
    description: "죽은 애니메이션 캐릭터들을 위한 추모공간 서비스",
    start_date: Date.parse("2025-03-01"),
    end_date: Date.parse("2025-11-30"),
    is_ongoing: false,
    demo_url: "https://choeae.yuuki08noah.com",
    stack: ["Ruby on Rails", "Vue.js", "PostgreSQL", "Docker"],
  },
  {
    title: "Draupnir",
    description: "Cilium 기반 멀티 클러스터 Zero Trust & Observability 아키텍처 설계",
    start_date: Date.parse("2025-09-01"),
    end_date: Date.parse("2025-10-31"),
    is_ongoing: false,
    stack: ["Kubernetes", "Cilium", "GKE", "IBM Instana", "Hubble UI", "Terraform"],
    itinerary: {
      purpose: "Cilium 기반 eBPF 기술을 활용해 GKE 멀티 클러스터 간 Zero Trust 통신과 Cross-Cluster Load Balancing을 구현하고, Hubble 및 IBM Instana로 가시성과 모니터링 체계를 구축",
      features: [
        "L4/L7 기반 Zero Trust 정책 구축 및 Cross-Cluster 통신 검증",
        "Echo Service를 활용한 Cross-Cluster Load Balancing 실증",
        "IBM Instana를 통한 실시간 서비스 모니터링 및 트레이싱 강화"
      ]
    }
  },
  {
    title: "M-ADP(Meister's Affordable Developer Platform)",
    description: "교내 클라우드 플랫폼 엔지니어링",
    start_date: Date.parse("2025-03-01"),
    is_ongoing: true,
    stack: ["Kubernetes", "ArgoCD", "Terraform"]
  }
]

projects_data.each do |project_data|
  # Generate slug manually for find_or_initialize_by
  base_slug = project_data[:title].parameterize
  slug = base_slug
  counter = 1
  while Project.where.not(title: project_data[:title]).exists?(slug: slug)
    slug = "#{base_slug}-#{counter}"
    counter += 1
  end
  
  project = Project.find_or_initialize_by(title: project_data[:title])
  project.user = user
  project.description = project_data[:description]
  project.start_date = project_data[:start_date]
  project.end_date = project_data[:end_date] unless project_data[:is_ongoing]
  project.is_ongoing = project_data[:is_ongoing]
  project.demo_url = project_data[:demo_url] if project_data[:demo_url]
  project.stack = project_data[:stack]
  project.itinerary = project_data[:itinerary] if project_data[:itinerary]
  project.slug = slug if project.slug.blank?
  
  project.save!
  puts "Created/Updated project: #{project.title}"
  
  # Add translations
  Translation.find_or_create_by!(
    translatable: project,
    locale: 'en',
    field_name: 'title'
  ) do |t|
    case project.title
    when "최애의 사인(死因)"
      t.value = "Choeae Sign (Memorial)"
    when "Draupnir"
      t.value = "Draupnir"
    when "M-ADP(Meister's Affordable Developer Platform)"
      t.value = "M-ADP (Meister's Affordable Developer Platform)"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: project,
    locale: 'ja',
    field_name: 'title'
  ) do |t|
    case project.title
    when "최애의 사인(死因)"
      t.value = "推しの死因"
    when "Draupnir"
      t.value = "ドラウプニル"
    when "M-ADP(Meister's Affordable Developer Platform)"
      t.value = "M-ADP（マイスターの手頃な開発者プラットフォーム）"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: project,
    locale: 'en',
    field_name: 'description'
  ) do |t|
    case project.title
    when "최애의 사인(死因)"
      t.value = "A memorial space service for deceased anime characters"
    when "Draupnir"
      t.value = "Multi-cluster Zero Trust & Observability Architecture Design based on Cilium"
    when "M-ADP(Meister's Affordable Developer Platform)"
      t.value = "School cloud platform engineering"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: project,
    locale: 'ja',
    field_name: 'description'
  ) do |t|
    case project.title
    when "최애의 사인(死因)"
      t.value = "亡くなったアニメキャラクターのための追悼空間サービス"
    when "Draupnir"
      t.value = "Ciliumベースのマルチクラスターゼロトラスト＆オブザーバビリティアーキテクチャ設計"
    when "M-ADP(Meister's Affordable Developer Platform)"
      t.value = "校内クラウドプラットフォームエンジニアリング"
    end
  end
end

# Create awards
awards_data = [
  {
    title: "2025 전공동아리 경진대회 금상",
    organization: "부산소프트웨어마이스터고등학교",
    description: "1위",
    date: Date.parse("2025-11-01")
  },
  {
    title: "2025 제 10회 전국 고등학교 동아리 소프트웨어 경진대회 동상",
    organization: "KAIST 및 4개 대학 총장상",
    date: Date.parse("2025-11-01")
  },
  {
    title: "2025 Silicon Valley AI Seminar & Project Pitching Workshop MOONSHOT AWARD",
    organization: "San Jose State University",
    description: "1st place",
    date: Date.parse("2025-06-01")
  },
  {
    title: "2025 교내 알고리즘 경진대회 최우수상",
    organization: "부산소프트웨어마이스터고등학교",
    description: "1위",
    date: Date.parse("2025-08-01")
  },
  {
    title: "2024 교내 알고리즘 경진대회 최우수상",
    organization: "부산소프트웨어마이스터고등학교",
    description: "1위",
    date: Date.parse("2024-08-01")
  },
  {
    title: "2024 카운터스펠 게임잼 지속가능한 목표 부문 동명대학교 ICT 융합대학장상",
    organization: "동명대학교",
    description: "최우수상",
    date: Date.parse("2024-11-01")
  }
]

awards_data.each do |award_data|
  award = Award.find_or_create_by!(
    title: award_data[:title],
    user: user
  ) do |a|
    a.organization = award_data[:organization]
    a.description = award_data[:description]
    a.date = award_data[:date]
  end
  puts "Created award: #{award.title}"
  
  # Add English translations
  Translation.find_or_create_by!(
    translatable: award,
    locale: 'en',
    field_name: 'title'
  ) do |t|
    t.value = case award.title
    when "2025 전공동아리 경진대회 금상"
      "2025 Major Club Competition Gold Prize"
    when "2025 제 10회 전국 고등학교 동아리 소프트웨어 경진대회 동상"
      "2025 10th National High School Club Software Competition Bronze Prize"
    when "2025 Silicon Valley AI Seminar & Project Pitching Workshop MOONSHOT AWARD"
      "2025 Silicon Valley AI Seminar & Project Pitching Workshop MOONSHOT AWARD"
    when "2025 교내 알고리즘 경진대회 최우수상"
      "2025 School Algorithm Competition Excellence Award"
    when "2024 교내 알고리즘 경진대회 최우수상"
      "2024 School Algorithm Competition Excellence Award"
    when "2024 카운터스펠 게임잼 지속가능한 목표 부문 동명대학교 ICT 융합대학장상"
      "2024 Counterspell Game Jam Sustainable Development Goals Category Tongmyong University ICT Convergence Dean's Award"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: award,
    locale: 'en',
    field_name: 'organization'
  ) do |t|
    t.value = case award.organization
    when "부산소프트웨어마이스터고등학교"
      "Busan Software Meister High School"
    when "KAIST 및 4개 대학 총장상"
      "KAIST and 4 Universities President's Award"
    when "San Jose State University"
      "San Jose State University"
    when "동명대학교"
      "Tongmyong University"
    else
      award.organization
    end
  end
  
  # Add Japanese translations
  Translation.find_or_create_by!(
    translatable: award,
    locale: 'ja',
    field_name: 'title'
  ) do |t|
    t.value = case award.title
    when "2025 전공동아리 경진대회 금상"
      "2025専攻サークルコンテスト金賞"
    when "2025 제 10회 전국 고등학교 동아리 소프트웨어 경진대회 동상"
      "2025第10回全国高校サークルソフトウェアコンテスト銅賞"
    when "2025 Silicon Valley AI Seminar & Project Pitching Workshop MOONSHOT AWARD"
      "2025シリコンバレーAIセミナー＆プロジェクトピッチングワークショップMOONSHOT AWARD"
    when "2025 교내 알고리즘 경진대회 최우수상"
      "2025校内アルゴリズムコンテスト最優秀賞"
    when "2024 교내 알고리즘 경진대회 최우수상"
      "2024校内アルゴリズムコンテスト最優秀賞"
    when "2024 카운터스펠 게임잼 지속가능한 목표 부문 동명대학교 ICT 융합대학장상"
      "2024カウンタースペルゲームジャム持続可能な目標部門東明大学ICT融合学部長賞"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: award,
    locale: 'ja',
    field_name: 'organization'
  ) do |t|
    t.value = case award.organization
    when "부산소프트웨어마이스터고등학교"
      "釜山ソフトウェアマイスター高等学校"
    when "KAIST 및 4개 대학 총장상"
      "KAIST及び4大学総長賞"
    when "San Jose State University"
      "サンノゼ州立大学"
    when "동명대학교"
      "東明大学"
    else
      award.organization
    end
  end
end

# Create milestones
milestones_data = [
  {
    title: "부산소프트웨어마이스터고등학교 입학",
    organization: "부산소프트웨어마이스터고등학교",
    period: "2024.03 - 현재",
    milestone_type: "education",
    details: "소프트웨어 개발 전공"
  },
  {
    title: "한성 장학생 12기",
    organization: "한성재단",
    period: "2024 - 2026",
    milestone_type: "scholarship"
  },
  {
    title: "알고리즘 동아리 활동",
    organization: "부산소프트웨어마이스터고등학교",
    period: "2024 - 현재",
    milestone_type: "activity"
  }
]

milestones_data.each do |milestone_data|
  milestone = Milestone.find_or_create_by!(
    title: milestone_data[:title],
    user: user
  ) do |m|
    m.organization = milestone_data[:organization]
    m.period = milestone_data[:period]
    m.milestone_type = milestone_data[:milestone_type]
    m.details = milestone_data[:details]
  end
  puts "Created milestone: #{milestone.title}"
  
  # Add English translations
  Translation.find_or_create_by!(
    translatable: milestone,
    locale: 'en',
    field_name: 'title'
  ) do |t|
    t.value = case milestone.title
    when "부산소프트웨어마이스터고등학교 입학"
      "Admission to Busan Software Meister High School"
    when "한성 장학생 12기"
      "Hansung Scholarship Student 12th Generation"
    when "알고리즘 동아리 활동"
      "Algorithm Club Activities"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: milestone,
    locale: 'en',
    field_name: 'organization'
  ) do |t|
    t.value = case milestone.organization
    when "부산소프트웨어마이스터고등학교"
      "Busan Software Meister High School"
    when "한성재단"
      "Hansung Foundation"
    else
      milestone.organization
    end
  end
  
  # Add Japanese translations
  Translation.find_or_create_by!(
    translatable: milestone,
    locale: 'ja',
    field_name: 'title'
  ) do |t|
    t.value = case milestone.title
    when "부산소프트웨어마이스터고등학교 입학"
      "釜山ソフトウェアマイスター高等学校入学"
    when "한성 장학생 12기"
      "ハンソン奨学生12期"
    when "알고리즘 동아리 활동"
      "アルゴリズムサークル活動"
    end
  end
  
  Translation.find_or_create_by!(
    translatable: milestone,
    locale: 'ja',
    field_name: 'organization'
  ) do |t|
    t.value = case milestone.organization
    when "부산소프트웨어마이스터고등학교"
      "釜山ソフトウェアマイスター高等学校"
    when "한성재단"
      "ハンソン財団"
    else
      milestone.organization
    end
  end
end

# Add user translations
Translation.find_or_create_by!(
  translatable: user,
  locale: 'en',
  field_name: 'name'
) { |t| t.value = "Sejun Noah Bang" }

Translation.find_or_create_by!(
  translatable: user,
  locale: 'ja',
  field_name: 'name'
) { |t| t.value = "方世準（バン・セジュン）" }

Translation.find_or_create_by!(
  translatable: user,
  locale: 'en',
  field_name: 'tagline'
) { |t| t.value = "A developer who never stops learning" }

Translation.find_or_create_by!(
  translatable: user,
  locale: 'ja',
  field_name: 'tagline'
) { |t| t.value = "学び続ける開発者" }

Translation.find_or_create_by!(
  translatable: user,
  locale: 'en',
  field_name: 'bio'
) { |t| t.value = "Hello, I'm Sejun Noah Bang, a developer who never stops learning. I aim to become a DevOps engineer who efficiently manages complex software. Recently, software has become increasingly complex, and the importance of software architecture has also grown." }

Translation.find_or_create_by!(
  translatable: user,
  locale: 'ja',
  field_name: 'bio'
) { |t| t.value = "こんにちは、学び続ける開発者のバン・セジュンです。私は複雑なソフトウェアを効率的に管理するDevOpsエンジニアになることを目標としています。最近、ソフトウェアはますます複雑になっており、ソフトウェアアーキテクチャの重要性も高まっています。" }

puts "\nSeeding completed successfully!"
puts "User: #{User.count}"
puts "Projects: #{Project.count}"
puts "Awards: #{Award.count}"
puts "Milestones: #{Milestone.count}"
puts "Translations: #{Translation.count}"
