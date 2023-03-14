# Project : Auction Item

![Frame 119](https://user-images.githubusercontent.com/78067919/224890977-638c0185-7236-4de8-8b2d-61e306a403df.png)

![Simulator_Screen_Recording_-_iPhone_14_Pro_-_2023-03-05_at_18_02_08_AdobeExpress](https://user-images.githubusercontent.com/78067919/222951475-5cae659c-8769-47c6-b075-7c48b03df477.gif)
![Simulator_Screen_Recording_-_iPhone_14_Pro_-_2023-03-03_at_15_12_40_AdobeExpress](https://user-images.githubusercontent.com/78067919/222949209-a2312756-32ba-466b-af08-bcddaab110a1.gif)
![Simulator_Screen_Recording_-_iPhone_14_Pro_-_2023-03-03_at_15_12_55_AdobeExpress](https://user-images.githubusercontent.com/78067919/222946917-f0838df4-b06b-40e5-8ccd-4eebd0f24085.gif)
![Simulator_Screen_Recording_-_iPhone_14_Pro_-_2023-03-05_at_17_58_48_AdobeExpress](https://user-images.githubusercontent.com/78067919/222951385-6183a7c1-829a-45e5-92f7-c7d27cad3db9.gif)

### 🔒 요구사항

> 물건을 단순히 가격을 올리고 그 가격에 맞게 파는 것이 아닌, 물건을 파는 사용자가 시작가격을 측정하고 사는 사용자들이 물건을 실시간으로 경매 함으로써 서로가 만족한 거래를 주선하는 플랫폼 개발
> 
- 실시간으로 가격 정보를 받고 물품을 경매하기 위한 양방향 통신 (TCP/IP Socket)
- 상품 리스트와 상품 이미지를 불러오기 위한 단방향 통신 (HTTP)
- 가격의 변동이 있을때 가격 UI 업데이트
- 사용자의 식별을 위한 로그인
- 사용자의 커뮤니케이션을 위한 채팅 기능 양방향 통신 (TCP/IP Socket)

---

### 😀 아키텍쳐

- **`Clea Architecture`**
    
    ![Frame 109 (3).png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8f288d99-958d-40c4-9444-96b0477b4190/Frame_109_(3).png)
    
    - Application Layer
        - SceneDIContainer
            - 의존성 주입을 관리하는 컨테이너 객체
        - Coordinator
            - 뷰의 흐름을 관리하는 객체
            - UIViewController의 ViewModel은 하나의 Coordinator에 의존성을 갖고있다.
        - Configure
            - xcconfig을 관리하고 서버 URL등을 제공하는 객체
                - Debug - localServer
                - Prod - Remote Server
                - Debug - Remote Server
    - Domain Layer
        - Model
            - 비즈니스 모델을 정의하는 객체
        - Usecase
            - 비즈니스 로직을 정의하는 객체
    - Presentation Layer
        - View, ViewController
    - Data Layer
        - 서버로 부터 받아온 데이터를 비즈니스 로직에 맞게 변환
    - Infrastructure Layer
        - 서버와 데이터를 송,수신 하는 객체
- **`MVVM-C`**
    
    ![Frame 106 (2).png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/666895e0-6197-44a2-b8a3-cd1badea85de/Frame_106_(2).png)
    
    - View
        - View 또는 ViewController가 될 수있다.
            - 부모 뷰는 자식 뷰에 의존하고 Delegate Pattern을 이용하여 자식 뷰는 부모 뷰로 Gesture, Touch에 대한 데이터’만’ 보낼 수 있다. 그 외의 데이터는 뷰 모델을 이용하여 데이터를 보낸다.
        - Subclassing을 하고 데이터를 필요로 한다면 ViewModel을 갖는다.
            - ViewModel의 Massive를 막고 모듈화를 하기 위함
    - ViewModel
        - Coordinator Delegate
            - ViewController의 ViewModel은 하나의 Coordinator에 의존한다.
            - “단일 책임 원칙” 뷰의 흐름 제어를 Coordinator 객체에 의존한다.
        - 부모 ViewModel → 자식 ViewModel
            - 부모의 뷰 모델은 자식 뷰 모델에 의존하고 데이터를 교환(Optional)
- 발견된 문제점
    - 위의 MVVM-C 규칙은 팀 마다 다를 수 있다.
        - 하나의 뷰 모델에 모든 자식 뷰가 의존 할 수 있다.
        - Gesture, Touch에 대한 데이터도 뷰 모델을 통해서 보낼 수 있다.
    - 프로젝트가 커질수록 빌드시간이 늘어나고 아무리 DIContainer를 써도 의존성이 복잡해진다.
- 해결 예정
    - RIBs 도입
        - 애매한 규칙은 없다. 틀이 정해져 있다.
    - Tuist 도입
        - 모듈화를 통해 프로젝트 단위로 나눈다. 의존성이 명확해지고, 빌드시간이 줄어든다.

---

### 🤘🏻 기능 개발

- `제품 리스트,이미지 HTTP 통신`
    - HTTP 통신을 이용하여 제품 리스트와 제품의 이미지를 수신하여 사용자에게 제공
- `Socket OutputStream Completion Handler 개발`
    - HTTP 통신과 다르게 양방향 통신인 TCP/IP Socket 통신은 Completion Handler가 없음
        - completion Handler id,Data Type,Splitter 이용하여 요청-응답 구조를 개발
- `Reduce Network Traffic`
    - 제품 리스트 상태를 저장해서 사용자가 불러온 리스트에 대해서만 실시간 데이터를 제공
        - HTTP 통신 → 리스트를 불러옴 → 사용자의 리스트 상태 1로 변경 → TCP/IP Socket 서버에 사용자의 상태를 업데이트 → 사용자가 불러온 리스트에 대해서 실시간 가격 변동 데이터 전송
        - 예시
            - 리스트가 product_id 정렬된 상태로 사용자에게 응답한다
            - 사용자는 15개씩 리스트를 불러오게 된다
            - A 사용자는 15개의 리스트를 응답 받았고 (상태 1), B 사용자는 30개의 리스트를 응답 받았다(상태 2).
            - product_id 가 5인 상품의 가격변동이 있을때 → A,B 사용자 모두에게 데이터 전송
            - product_id 가 16인 상품의 가격변동이 있을때 → B 사용자에게만 데이터 전송
- `TCP/IP Socket`
    - URLSessionStreamTask로 서버와의 InputStream,OutputStream의 Connection을 맺는다. InputStream에 들어오는 데이터를 지속적, 비동기로 받아오기 위해서 RunLoop위에 InputData를 받아올 수 있도록 한다.
        - Connect To Server
            
            ```swift
            private func connect() {
                    let streamTask = urlSession.streamTask(withHostName: self.hostName, port: self.portNumber)
                    streamTask.delegate = self
                    streamTask.captureStreams()
                    streamTask.resume()
                }
            ```
            
        - Runloop
            
            ```swift
            func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
                    shouldKeeping = true
                    currentRunloop = RunLoop.current
                    self.inputStream = inputStream
                    self.outputStream = outputStream
                    self.inputStream?.delegate = self
                    self.outputStream?.delegate = self
                    self.inputStream?.schedule(in: .current, forMode: .default)
                    self.outputStream?.schedule(in: .current, forMode: .default)
                    self.inputStream?.open()
                    self.outputStream?.open()
                    while(shouldKeeping&&RunLoop.current.run(mode: .default, before: .now+1.0)){}
                }
            ```
            
        - StreamDelegate
            
            ```swift
            extension SocketNetwork:StreamDelegate{
                func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
                    switch eventCode {
                    case .openCompleted:
                        print("connect")
                        isSocketConnected.onNext(.connect)
                    case .hasBytesAvailable:
                        if aStream == inputStream {
                            var dataBuffer = Array<UInt8>(repeating: 0, count: 4096)
                            var len: Int
                            len = (inputStream?.read(&dataBuffer, maxLength: 4096))!
                            if len > 0 {
                                let data = Data(bytes: &dataBuffer, count: len)
                                inputDataObserver.onNext(.success(data))
                            }
                        }
                    case .hasSpaceAvailable:
                        break;
                    case .errorOccurred:
                        inputDataObserver.onNext(.failure(StreamError.Unknown))
                        break;
                    case .endEncountered:
                        inputDataObserver.onNext(.failure(StreamError.Disconnected))
                        isSocketConnected.onNext(.disconnect)
                        disconnect()
                        connect()
                    default:
                        print("Unknown event")
                    }
                }
            }
            ```
            

---

### 📋 문제 & 해결

- **`animation Hitch Issue`**
    - 문제
        - Custom Navigation View를 Animation 할때 Hitch가 발생함
        - Hitch → expensive Commit
        - 수정 전 애니메이션 영향있는 뷰 BackgroundView에서 layoutIfNeeded를 실행하면 서브뷰들도 레이아웃이 바뀌게 되는지 여부에따라 layoutSubview가 실행된다.
        - Expensive Commit → 너무 많은 서브뷰가 커밋이 돼서 Hitch가 발생한다는 뜻
            
            ```bash
            - ContainerViewController Root View
            -- BackgroundView (self.view.layoutIfNeeded)
            --- Custom Navigation View
            ---- Content View
            ----- TableView
            ------ TableViewCell
            ```
            
    - 해결
        - 애니메이션 영향있는 뷰를 BackgroundView와 Custom Navigation View로 변경하고 Content View를 애니메이션 Completion에서 보여주는 방법을 채택.
            
            ```bash
            - ContainerViewController Root View
            -- BackgroundView (self.view.layoutIfNeeded)
            --- Custom Navigation View
            .
            .
            .
            //completion
            Add Content View & Animation Content View Alpha
            ```
            
    
- `실시간 가격변동에 대한 UICollectionView Update Issue`
    - 문제
        - RxCocoa UIColletionView items Method
            
            ```swift
            func collectionView(_ collectionView: UICollectionView, observedElements: [Element]) {
                    self.itemModels = observedElements
                    collectionView.reloadData()
            
                    // workaround for http://stackoverflow.com/questions/39867325/ios-10-bug-uicollectionview-received-layout-attributes-for-a-cell-with-an-index
                    collectionView.collectionViewLayout.invalidateLayout()
                }
            ```
            
        - 가격변동 → Observable에 방출된 상품배열 변동 → 새로운 값을 방출 → UICollectionView reloadData(), Layout invalidateLayout() → 모든 셀에 적용이 된다 → 필요없는 비용이 발생한다.
    - 해결
        - RxDataSources 도입
            - RxDataSources는 방출되는 데이터 값이 Equatable을 채택하고 비교하여, 변경이 된 데이터의 셀만 insert,reload,delete 할 수 있게하는 프레임워크이다.
            - 하지만 이 프레임워크 또한 문제는 존재했다.insert,reload,delete를 한 후에 invalidateLayout을 무조건 하는것.
            - 가격변동이 있을때 가격을 표시하는 UILabel의 텍스트 값만 바꾸기 때문에 레이아웃을 무효화하고 다시 보여주는것은 필요없는 비용이 발생하는것이다.
            - RxDataSource code
                
                ```swift
                switch dataSource.decideViewTransition(dataSource, collectionView, differences) {
                                    case .animated:
                                        // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                                        // this is a limitation of Diff tool
                                        print(differences)
                                        for difference in differences {
                                            let updateBlock = {
                                                // sections must be set within updateBlock in 'performBatchUpdates'
                                                dataSource.setSections(difference.finalSections)
                                                collectionView.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                            }
                                            //performBatchUpdates는 invalidateLayout()을 호출한다.
                                            collectionView.performBatchUpdates(updateBlock, completion: nil)
                                        }
                                        
                                    case .reload:
                                        dataSource.setSections(newSections)
                                        collectionView.reloadData()
                                        return
                                    }
                ```
                
        - RxDataSource Subclassing
            - RxDataSource를 Subclassing해서 insert,delete일때만 PerformBatchUpdates를 실행 하게하고 reload(가격이 변동될때)는 실행하지 않게 한다.
            - Subclassing RxDataSource Code
                
                ```swift
                switch dataSource.decideViewTransition(dataSource, collectionView, differences) {
                                    case .animated:
                                        // each difference must be run in a separate 'performBatchUpdates', otherwise it crashes.
                                        // this is a limitation of Diff tool
                                        for difference in differences {
                                            if self?.returnWithOutReload(dif: difference) == true{
                                                let updateBlock = {
                                                    // sections must be set within updateBlock in 'performBatchUpdates'
                                                    dataSource.setSections(difference.finalSections)
                                                    collectionView.batchUpdates(difference, animationConfiguration: dataSource.animationConfiguration)
                                                }
                                                
                                                collectionView.performBatchUpdates(updateBlock, completion: nil)
                                            }else if let index = self?.returnReloadIndexPath(dif: difference){
                                                collectionView.reloadItems(at: index)
                                                dataSource.setSections(difference.finalSections)
                                            }
                                        }
                                        
                                    case .reload:
                                        dataSource.setSections(newSections)
                                        collectionView.reloadData()
                                        return
                                    }
                ```
                
                ```swift
                private func returnWithOutReload<T:AnimatableSectionModelType>(dif:Changeset<T>)->Bool{
                        dif.insertedItems.isEmpty && dif.deletedItems.isEmpty && dif.movedItems.isEmpty ? false : true
                    }
                    
                    private func returnReloadIndexPath<T:AnimatableSectionModelType>(dif:Changeset<T>)->[IndexPath]{
                        var arrayIdx:[IndexPath] = []
                        dif.updatedItems.forEach { itemPath in
                            arrayIdx.append(IndexPath(item: itemPath.itemIndex, section: itemPath.sectionIndex))
                        }
                        return arrayIdx
                        
                    }
                ```
                
        - Subclassing UICollectionView
            - reloadItems를 Override하고, 스크롤의 부드러운 움직임을 위해 스크롤이 되지 않을때 보이는 셀에 대해서만 가격변동 애니메이션을 실행하도록 한다.
                
                ```swift
                override func reloadItems(at indexPaths: [IndexPath]) {
                        if !isScrolling{
                            for i in 0..<indexPaths.count{
                                if let cell = self.cellForItem(at: indexPaths[i]) as? ProductListCollectionViewCell,self.visibleCells.contains(cell){
                                    let animationValue = self.viewModel.returnAnimationValue(index: indexPaths[i])
                                    cell.animationObserver.onNext(animationValue)
                                }
                            }
                        }
                    }
                ```
