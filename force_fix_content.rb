
project = Project.find_by(slug: '최애의-사인')
doc = project.blog_posts.find_by(category: 'overview')

# I'm defining the fixed content directly to ensure it matches the desired output.
# I'm keeping the top part standard and just fixing the layout block section.

new_content = <<~MARKDOWN
## 🖥️ 프로젝트 오버뷰

## 최애의 사인(**死因) - [windeath44.wiki](https://windeath44.wiki)**

***Windows95* 인터페이스**로 구현된, 애니메이션 캐릭터를 위한 디지털 애도 플랫폼

저희는 애니메이션 팬덤을 위한, 애니메이션 캐릭터 추모 서비스 ***‘최애의 사인(死因)’*** 을 제작하였습니다.

처음엔 단순한 ‘좋아함’에서 출발한 프로젝트였지만, 탐구를 거듭하며, **새로운 세대의 감정과 기억이 머무는 새로운 공간**, 즉 ***‘디지털 애도(digital mourning)’*** 의 형태로 발전하게 되었습니다.

저희는 이제 **가상공간**에서의 **기억과 애도의 새로운 방식**을 제안하고자 합니다.

사용자는 자신이 사랑했던 캐릭터를 추모하며, AI와의 대화·재판·헌화(추후 개발) 등의 기능을 통해 새로운 세대의 감정 표현 방식을 자연스럽게 경험할 수 있습니다.

출발은 가벼운 대중문화 탐구였지만, 사회적 의미와 감성적 경험을 함께 담아내는 프로젝트로 성장하겠습니다.

> **슬로건 | *PARADOX (역설)***
> 

**역설**이란, 의미가 모순되고 이치에 맞지 않는 표현을 뜻합니다.

애니메이션 캐릭터는 **늙지도, 사라지지도 않습니다.** 
하지만 우린 작품에서 **스토리상 죽은 캐릭터**를 "죽었다"고 생각하며 이를 **슬퍼하고 추모**합니다.

현실의 장례식에서 ‘슬픔’과 ‘재미’는 공존할 수 없지만, 캐릭터의 죽음은 누군가에게는 슬픔이자, 또 다른 누군가에게는 흥미로운 사건이 되기도 합니다.  이 모순된 감정의 경계에서, *‘**최애의 사인(死因)’*** 은 만들어졌습니다.

### 사진

---

![Image](https://noah-portfolio-v2.s3.ap-northeast-2.amazonaws.com/e8mi0t5gsq7p4cyz7ui0331j37ku?response-content-disposition=inline%3B%20filename%3D%22image.png%22%3B%20filename%2A%3DUTF-8%27%27image.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXTORPJUVUE7F6RJY%2F20251208%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20251208T055000Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=e7ac9c5ef5558c224a615b84d9c27147f78dd59ae5d2b733df81d1e29b2b5de1)

![Image](https://noah-portfolio-v2.s3.ap-northeast-2.amazonaws.com/svmoryu56h29weelu3w5thxby5l6?response-content-disposition=inline%3B%20filename%3D%22image.png%22%3B%20filename%2A%3DUTF-8%27%27image.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXTORPJUVUE7F6RJY%2F20251208%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20251208T055058Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=5960bdfabef8f6d74f166b50c62d41a37cb37c36470fcf8a1a587dbe799f0c20)

30일 요청 수

## 📌 최애의 사인

### 최애(**最愛**) : 자신이 가장 사랑하는 사람

사인(死因) : **사망한 이유**

가장 사랑하는 사람의 죽은 이유라는 뜻으로, 나의 최애 캐릭터가 죽은 이유를 뜻합니다.

'사인(死因)'은 캐릭터의 사망 이유를 의미하며, 그들의 이야기에 담긴 희생, 운명, 혹은 비극적인 순간을 떠올리게 합니다. 

이는 단순히 죽음을 넘어, 그 캐릭터의 삶과 서사를 다시 기억하고 기릴 수 있는 계기를 제공합니다.

결국 **최애의 사인(死因)** 은 팬들이 가장 사랑했던 캐릭터의 삶과 죽음을 진지하게 되새기며, 그들과의 연결을 공유하고 공감할 수 있는 공간이라는 메시지를 담고 있습니다.

## 📌 문제 정의

### “작품에 깊게 몰입한 많은 사람들은 캐릭터가 죽을 때 슬픔을 느낀다.” 
만약 자신의 최애 캐릭터가 죽는다면 어떤 기분이 들까요?

<div class="layout-row">
<div class="layout-col">

![Image](https://noah-portfolio-v2.s3.ap-northeast-2.amazonaws.com/m9e0tttb9oc99jmvwnx5qpc9tprz?response-content-disposition=inline%3B%20filename%3D%22image.png%22%3B%20filename%2A%3DUTF-8%27%27image.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXTORPJUVUE7F6RJY%2F20251208%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20251208T055423Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=09b4d24f454c67bfd2534c6c1ca110af6438583194e1c21d89445996501a4ba0)

</div>
<div class="layout-col">

![Image](https:/noah-portfolio-v2.s3.ap-northeast-2.amazonaws.com/0u53urdt9z37a2g5pp7ot7l003ow?response-content-disposition=inline%3B%20filename%3D%22image.png%22%3B%20filename%2A%3DUTF-8%27%27image.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAXTORPJUVUE7F6RJY%2F20251208%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20251208T055339Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=b536a28610a6e0d16277b9da5faff236609d0bfb6e2c34f4170013cf318d4a9e)

</div>
</div>

위 자료는 캐릭터들의 죽음에 대해 이야기하고 있는 모습에 대한 자료입니다. 위와 같이 여러 사람들이 트위터라는 플랫폼으로 캐릭터의 죽음에 대해 슬퍼하고, 공감하는 것을 알 수 있습니다. 그러나, 트위터는 아시다시피 공개적이라는 점이 문제가 될 때가 많습니다. 친구들끼리, 혹은 애니메이션 매니아들끼리의 비공개 계정이어도 사람마다 본 애니메이션이, 또는 진척도가 다른 경우가 많죠. 한 애니메이션 매니아와의 인터뷰 결과, 다음과 같은 문제점이 발견되었습니다.


- 스포일러 우려로 최애 캐릭터의 죽음에 대한 슬픔을 쉽게 공유하지 못한다는 점
    
    애니메이션을 보다가 최애 캐릭터가 죽었는데 친구, 혹은 커뮤니티에 말하면 스포가 되니까 어디에 말도 못하겠고, 혼자서 찾아보려고 해도 잘 나오지 않아서 너무 괴로워요. 슬픔은 나누면 반이 된다고 하는데, 스포가 되니 아무한테도 말 못하고 혼자 꼬옥 안고있어야만 한다는게 진짜 너무 괴로워요.
    
- 다른 정보를 찾다가, 원치 않는 스포일러를 당한 경험이 불쾌했다는 점
    
    의도치 않게 애니메이션에 대해서 찾아보다가 생각지도 못한 캐릭터가 사망한다는 스포를 당했어요. 그때의 감정은 욕설 없이는 표현할 수 없을 거에요. 나온지 얼마 안된 애니메이션인데 벌써부터 스포일러를 하는 것은 정말 예의 없지 않나요?
    
- 인기 없는 캐릭터의 죽음을 함께 이야기할 공간이 부족한 점
    
    저는 한 때 별로 유명하지 않은 애니메이션의 별로 인기도 없는 캐릭터를 좋아했던 적이 있어요. 그런데 단역으로 나왔던 그 캐릭터는 1화만에 죽어버렸죠... 여기저기 돌아다니며 슬픔을 공유할 곳을 찾았지만 결국 나오지 않았어요.
    


정리하자면, **스포 & 유명도 이슈로 슬픔을 나눌 곳이 없다**라는 겁니다.
MARKDOWN

doc.update!(content: new_content)
puts "Updated content!"
