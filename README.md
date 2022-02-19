
# ios 프로그래밍 Term Project 보고서

## 🔎제목

일정 관리 어플리케이션

## 🔎앱 개요 및 구조

### 개요

캘린더에 일정을 등록하여 관리할 수 있는 어플리케이션이다. 캘린더에 날짜를 클릭하면 해당 날짜에 등록된 일정 리스트를 보여준다. 해당 화면에서 새로운 일정을 추가할 수 있고, 기존에 있던 일정을 클릭하면 세부 정보를 보거나 수정도 가능하다. 일정 삭제는 왼쪽으로 밀어서 삭제를 할 수 있다. 특정 날짜에 이벤트가 하나 이상 등록되면 캘린더 날짜 하단에 표시가 되어 일정 등록 여부를 알 수 있다. 

### 구조

![KakaoTalk_Photo_2022-02-19-14-20-48](https://user-images.githubusercontent.com/69784492/154787506-4ddd0212-eab5-446c-af0a-267664b01b63.jpeg)

## 🔎 앱 기능

### 캘린더 화면

- 처음 어플리케이션을 들어가면 파란색 원으로 오늘 날짜에 표시되어 있다. 캘린더에서 위 아리로 넘기면 다른 월의 달력을 볼 수 있다. 캘린더에 각 날짜를 터치하면 선택한 날짜에 보라색 원으로 표시되고, 하단 테이블 뷰에 등록된 일정 목록들이 나타난다. 날짜를 터치하고 상단의 추가 버튼을 누르면 새로운 일정을 추가할 수 있다. 테이블 뷰의 일정을 하나 터치하면 수정을 할 수 있다.
- 날짜를 클릭하면 중간에 있는 텍스트 레이블에 선택한 날짜가 텍스트로 나타난다.
- 각 날짜에 일정이 하나 이상 등록되면 달력의 날짜 하단에 점으로 일정이 등록되어 있다는 표시가 나타난다. 이 표시로 일정 등록 여부에 대해 한 눈에 알 수 있게 된다.

### 일정 등록 및 수정 화면

- 캘린더 화면에서 날짜를 터치 후 상단의 추가 버튼을 누르면 새로운 일정 등록 화면으로 넘어간
다. 새로운 일정 객체를 생성하고, 각 데이터를 입력 후 저장 버튼을 누르면 생성된 객체가 저장 되어 일정 목록을 보관하는 배열에 저장된다. 저장 후 다시 캘린더 화면으로 돌아가면 테이블 뷰 에 일정이 새로 추가됨을 볼 수 있다.
- 캘린더 화면의 테이블 뷰에서 일정 셀을 터치하면 일정 수정 화면으로 넘어간다. 일정 등록과 같은 화면이지만 기존에 생성한 객체를 가져와 데이터를 넣어서 수정하거나 메모를 볼 수 있다. 수정을 하고 저장을 한 후 캘린더 화면으로 돌아가면 일정이 수정됨을 볼 수 있다.

## 🔎 구현 내용

- navigationBar를 이용하여 ViewControlle와 일정 등록 및 수정 뷰인 AddController를 연결하였다. ViewController에 Bar Button Item을 이용하여 새로 일정 추가 버튼을 만들고, 버튼을 AddViewController와 연결시켰다.
- 각 일정들의 데이터를 가지고 있는 Schedule클래스와 각 일정들을 날짜별로 저장하기 위해 ScheduleList클래스에 Schedule 객체 배열을 생성하였다. 날짜마다 생성된 ScheduleList를 한번에 관 리하기 위해 DateList 클래스를 만들었다.

### ViewController(캘린더, tableView)

- 캘린더는 FSCalendar 라이브러리를 사용하였다. 각 날짜를 클릭할 때 날짜를 string타입으로 변환
하여 textLabel에 넣는다. 날짜를 클릭할 때 해당 날짜에 등록된 schedule객체가 있는지 확인 후 있 으면 하단의 tableView에 띄운다.

```swift
extension ViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        dateStr = dateFormatter.string(from: date)
        dateLabel.text = dateStr
        
        calendar.appearance.eventDefaultColor = UIColor.red
        calendar.appearance.eventSelectionColor = UIColor.red
        
        //스케줄이 등록되어 있는지 확인 후 테이블 뷰 reload
        if let text: String = dateStr {
            scheduleList = dateList?.find(date: text)
            scheduleTableview.reloadData()
        }
    }

}
```

- schedule객체를 날짜에 맞게 scheduleList 클래스에 배열로 보관하였고, 각 scheduleList들을 날짜정 보와 함께 dateList에 보관하였다. dateList에 find라는 함수를 정의하여 클릭한 날짜의 객체가 생 성이 됐는지 확인을 하여 scheduleList객체를 가지고 온다.

```swift
func find(date: String) -> ScheduleList{
        var sc = ScheduleList(date: date)
        if scheduleLists.count == 0{
            return sc
        }
        for i in 0...scheduleLists.count-1{
            if scheduleLists[i].date == date {
                sc = scheduleLists[i]
                break
            }
            
        }
        return sc
    }
```

- tableViewCell의 식별자를 통하여 위에서 가지고 온 scheduleList에 있는 schedule배열을 인덱스로 접근하여 tableView에 각 일정을 보여준다. 셀의 스타일은 Right Detail로 하여 Title에는 일정의 제 목을 Detail에는 일정의 시작시간 ~ 끝시간이 출력되게 하였다.

```swift
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addVC = segue.destination as! AddViewController
        if segue.identifier == "addSc"{
            schedule = Schedule(title: "", date: "", start: "", finish: "", memo: "")
            addVC.schedule = schedule
            addVC.date = dateStr
        }
        if segue.identifier == "editSc"{
            if let row = scheduleTableview.indexPathForSelectedRow?.row{
                schedule =  scheduleList.schedules[row].clone()
                addVC.schedule = schedule
                addVC.date = dateStr
            }
        }
    }
}
```

- viewController에서 AddViewController로 넘어갈 때 두가지 방식으로 넘어간다. 새로 일정 등록할 시 “addSc” 식별자로 넘어갈 때는 빈 Schedule객체를 넘기고, 날짜 정보만 넘겨준다. 기존에 등록된 일정을 클릭하여 넘어갈 때는 “editSc” 식별자를 통해 넘어가고, tableView에서 선택한 셀의 인덱스 번호로 Schedule객체를 찾아낸다. 찾은 객체를 날짜 정보와 함께 넘겨준다.

### 일정 등록 및 수정 [AddViewController]

- viewDidLoad()함수에서 넘겨받은 schedule객체를 설정해준다.
- 기존에 등록한 일정을 넘겨받았을 경우에는 일정 제목과 시간, 메모 정보를 각 칸에 알맞게 설정
해준다. 일정을 새로 등록할 경우에는 시간 정보를 가지고 있지 않으므로, 입력하고 있는 현재 시
간이 디폴트 값으로 설정된다.
- 일정 정보 입력 또는 수정을 다 하면 상단의 Save버튼을 누르면 입력 해 놓은 데이터들을 Schedule객체에 넣는다.

### 등록한 일정을 테이블에 띄우기 [ViewController]

- AddViewController에서 저장한 Schedule객체를 ViewController의 viewDidappear()함수 내에서 받는다.

```swift
if let text: String = dateStr {
    scheduleList = dateList?.find(date: text)
}
//수정 시
if let indexPath = scheduleTableview.indexPathForSelectedRow{
    
    guard let scheduleClone = schedule else {return}
    if scheduleClone.isEqual(schedule: scheduleList.schedules[indexPath.row]) == false{
        scheduleList.modifySchedule(schedule: scheduleClone, index: indexPath.row)
        scheduleTableview.reloadRows(at: [indexPath], with: .automatic )
    }
    scheduleTableview.reloadRows(at: [indexPath], with: .automatic )
    scheduleTableview.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    scheduleTableview.cellForRow(at: indexPath)?.backgroundColor = .white
    
}
```

- dateList 클래스를 통해 날짜에 맞는 ScheduleList 객체를 찾는다.
- 기존에 등록한 리뷰를 수정한 경우, 선택했던 열의 인덱스 번호로 Schedule객체를 접근하고, 넘 겨받은 schedule객체로 수정해준다.

```swift
//새로운 일정 등록
else if let scheduleClone = schedule{
    //타이틀 입력 안되면 생성x
    if scheduleClone.title.isEmpty{
        return
    }
    
    scheduleList.addSchedule(schedule: scheduleClone)
    let indexPath = IndexPath(row: scheduleList.count()-1, section: 0)
    scheduleTableview.insertRows(at: [indexPath], with: .automatic)
    
    if scheduleList.count() == 1{
        if !dateList!.isExit(date: dateStr){
            dateList?.addList(scheduleList: scheduleList)
        }

    }
}
```

- 새로 등록한 리뷰는 제목이 입력 안된 경우는 일정 등록을 하지 않고, 올바르게 입력된 객체는
scheduleList의 schedule배열에 추가해준다. 그 다음 tableView에 열을 추가하여 삽입한다.
만약 해당 날짜에 처음으로 일정이 추가됐다면 scheduleList를 dateList 클래스의 배열에 추가해야한다. scehduleList에 데이터가 1개만 들어있고, 한번도 등록된 적이 없다면 추가했다.

### 달력에 이벤트 등록 여부 표시 [ViewController]

- 위의 viewDidAppear에서 일정을 새로 등록 후에 이벤트 등록 여부를 표시해주기 위해 날짜 정보 를 저장을 해야 한다. 때문에 DateList 클래스에 날짜를 저장하기 위한 문자열 배열 event를 선언 하였다. scheduleList를 dateList에 추가할 때 해당 날짜를 event배열에 추가한다.

```swift
//이벤트 표시 위해서
if dateList?.event.count != 0 {
    print("--")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy-MM-dd"
    eventDate.append(dateFormatter.date(from: dateList!.event[dateList!.event.count-1])!)
    calendar.reloadData()
    customCalendar()
}
```

- tableView에 등록 후에 dateList의 event배열에 들어있는 날짜를 ViewController내에 선언한 배열인 eventDate배열에 넣어준다. 그 후 캘린더를 reload를 해준다.

```swift
extension ViewController{
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            if self.eventDate.contains(date){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YY-MM-dd"
                let d = dateFormatter.string(from: date)
                if dateList?.find(date: d).count() == 0{
                    return 0
                }
                
                return 1
            }
            return 0
        }
    
}
```

- reload함수를 호출하게 되면 위의 함수도 호출된다. 이 함수에서는 eventDate에 포함되어있는 날짜 를 찾고, scheduleList 내에 일정이 1개 이상 있을 때 1을 리턴 하면서 캘린더에 이벤트 여부 표시 가 생긴다. 특정 날짜에 일정이 있다가 모두 삭제되면 다시 표시가 없어진다. 때문에 일정 삭제 시 calendar.reload()를 호출한다.

## 🔎 실행 화면

- 캘린더 화면에 일정 등록 여부가 표시되어 있다.

![Untitled](https://user-images.githubusercontent.com/69784492/154787527-23ad31e9-2332-46c5-a7b2-fdfffaacd206.png)

- 일정이 등록되어 있는 화면

![1](https://user-images.githubusercontent.com/69784492/154787535-ae4d09a0-a6b1-4525-ab6c-5c3754cb1184.png)

- 일정 등록 화면

![2](https://user-images.githubusercontent.com/69784492/154787546-7b1ca048-de3d-4ecc-b314-654ed1fda532.png)

## 결론

수업을 듣고 실습을 따라하는 과정만 했을 때는 앱의 구조나 문법 등이 쉽게 익혀지지 않았다. 이 프로젝트를 통해서 이전 강의자료를 다시 꺼내 보며 공부하고 검색하고 이전 실습 코드들을 다시 돌려보고 하면서 감이 잡히지 않았던 개념이 잡혔다. 잘 모르고 부딪히다 보니 별거 아닌 이유로 한참을 붙잡고 오류를 찾아내는 경우도 많았는데, 그러한 과정을 거친 덕분에 하면 할수 록 개념이 좀 이해가 되고, 구조가 그려졌다.
좀 더 제대로 공부해서 이해가 된 상태에서 프로젝트를 시작했더라면 처음 계획했던 만큼 만들 어낼 수 있었을 것 같은데 오류를 고치고 계속 부딪히는 과정에 시간을 많이 쓰다 보니 계획 한 거에 비교하여 작은 규모가 돼서 조금 아쉽다. 그래도 이러한 과정으로 공부가 되고 얻어가는 것 이 있어서 좋은 시간이었다.
