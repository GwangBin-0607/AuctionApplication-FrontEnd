# Project : Auction Item

- 프로젝트 스크린샷
- 이미지
- 프로젝트 기간
    - 2022.10 ~
- 프로젝트 내용
    - 사용자의 물품을 경매를 통해 거래를 주선하는 플랫폼 개발
- 프로젝트 구조
    - Clean Architecture
        - Domain
            - Entity
                - Business Model
            - Usecase
                - Business Logic
        - Presentation
            - View
                - ViewController OR View
            - ViewModel
                - ViewController OR View에 바인딩하는 객체
        - Data
            - DataTransfer
                - 서버로 부터 받아오거나 보낼 데이터를 인코딩, 디코딩 하는 객체
            - Repository
                - 인코딩, 디코딩 된 데이터를 Usecase Layer로 전달하는 객체
        - Infrastructure
            - HTTP
                - HTTP 통신 서비스를 하는 객체
                - 제품 리스트, 제품의 이미지 Request-Response 형식으로 데이터 교환
            - TCP / IP Socket
                - 실시간 데이터를 주고 받는 객체
                - 제품의 실시간 가격 데이터를 받아와서 Data Layer에 전송한다.
        - Application
            - SceneDIContainer
                - 의존성 주입을 위한 객체
            - Container Controller
                - Custom Container Controller를 구현하여 View Controller의 전환에 대한 애니메이션을 구현
            - Configure
                - Local Server, Release Server의 URL에 대한 정보를 저장하고 제공하는 객체
            - Coordinator
                - ViewController의 View Flow로의 의존으로 부터 분리하는 객체
    - Dependency Flow
        
        ![Frame 98](https://user-images.githubusercontent.com/78067919/222644174-259f942d-4795-430a-8bb9-92668a804a71.png)
        

- 패턴
    - MVVM-C
        - View는 다수의 View를 갖고 있고 View는 데이터의 교환이 필요하게 되면 ViewModel 에 의존한다.
        - Massive ViewModel을 피하기 위해 분리 될 수 있다면 자식의 뷰가 별도의 ViewModel에 의존한다.
        - 부모의 뷰 모델은 필요하다면 자식의 뷰 모델을 의존하고 데이터 교환을 할 수 있다.
        - 부모 View는 자식의 View의 Gesture, Click 같은 모션에 대해서 Delegate Pattern을 이용하여ViewModel과 분리한다.(Weak)
        - Controller ViewModel은 Coordinator Delegate를 의존하고 ViewController를 View Flow로 부터 분리시킨다.
    - MVVM-C Diagram
        
        ![Frame 106](https://user-images.githubusercontent.com/78067919/222644354-91f6e061-329e-4c6d-934c-a36fc7a5b215.png)

