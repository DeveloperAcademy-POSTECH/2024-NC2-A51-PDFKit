# 2024-NC2-A51-PDFKit
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About PDFKit

PDFKit은 PDF를 활용할 수 있도록 하는 프레임워크입니다.

**주요기능**

- PDF 화면을 띄우고, ```확대```하거나 ```축소```
- PDF ```썸네일```(미리보기 화면) 생성
- PDF 파일 내의 ```텍스트 또는 이미지 추출```, ```텍스트 검색```
- 텍스트, 하이라이트, 또는 도형 모양 등 PDF ```주석 추가```
- 새 PDF를 ```생성```하거나, 페이지를 ```추가``` 또는 ```제거```, ```순서 변경```, ```추출``` 등 기존 PDF 수정하기
- PDF의 ```병합```, PDF 문서의 ```비밀번호``` 설정

<br>


## 🎯 What we focus on?

> **PDF 특정 텍스트 검색, PDF 주석 추가**

🤔 왜 우리가 이 기능에 집중했을까?
- PDF 문서를 보여주는 것 이외에, PDFKit을 활용할 수 있는 다양한 기능에 조금 더 집중하고자 했습니다.

<br>


## 💼 Use Case


```Use Case``` 개인정보를 찾아 가려주고,사용한 문서를 한 곳에서 모아보자!



## 🖼️ Prototype
![PDFKitPrototype](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A51-PDFKit/assets/113221248/ece02542-1eda-4ad9-8c92-7fa31ab6d718)
* PDF를 불러오기 / 사용한 문서를 앱 내에 모아보고 불러오기
* PDF 파일에서 원하는 텍스트를 찾아 픽커에서 고른 색상의 사각형 주석으로 덮어주기
* 내보내기 (공유하기)

## 🛠️ About Code

### **1️⃣ PDF 특정 텍스트 검색**
### **2️⃣ PDF 주석 추가**

- SwiftUI에 연결하기 위해 PDFViewRepresentable을 활용
- PDFView()를 생성하고, pdfView.document에게 PDFDocument(url: url)을 이용해 PDF를 가져와 적용
- PDFDocument의 findString으로 텍스트를 찾아 반환되는 PDFSelection을 이용하여 특정 텍스트의 영역을 통해 주석 적용 (가려주기)
- PDFAnnotation을 만들고 사용자가 지정한 색상으로 변경, setValue를 이용하여 지우고자 한 텍스트 각각 구분
