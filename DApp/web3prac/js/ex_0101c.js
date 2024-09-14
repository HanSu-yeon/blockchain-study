/**
 * MetaMask와 연동하여 계정 정보를 불러오는 기능을 가진 코드
 * 1. 블록체인 네트워크에 연결
 * 2. 계정의 잔고 및 거래 횟수 표시
 */
App = {
  // Web3 객체 변수.
  web3: null,

  // 블록체인에 연결해 주는 함수
  //web3 객체 초기화, 메타마스크와 연결하는 역할
  initWeb3: function () {
    //웹 페이지에 메타마스크(또는 web3 제공 객체)가 있는지 확인
    //메타마스크가 설치되어 있으면 window.ethereum 객체가 존재함
    if (typeof web3 !== 'undefined') {
      console.log('Web3 불러왔습니다.');
      //메타마스크와 사이트를 연결할 수 있도록 요청(사용자에게 메타마스크 팝업을 띄워 계정 연결을 요청하는 과정)
      window.ethereum.request({ method: 'eth_requestAccounts' });
      //메타마스크가 있는지 확인
      if (window.ethereum.isMetaMask) {
        //메타마스크를 통해 web3 객체를 초기화함 => 이를 통해 블록체인과 상호작용할 수 있음
        this.web3 = new Web3(window.ethereum);
        console.log('MetaMask 준비됨.');
      } else {
        console.log('MetaMask 사용 불가.');
      }
    } else {
      console.log('오류! Web3를 불러 올수 없습니다.');
    }
  },

  //계정 정보 보여주기
  showAccountInfo: async function () {
    let accounts = await this.web3.eth.getAccounts(); //현재 사용자의 계정 목록 불러옴
    let account = accounts[0]; //연결된 계정 중 첫 번째 계정을 가져와서 사용함
    let balance = await this.web3.eth.getBalance(account); //해당 계정의 이더리움 잔액(Wei단위로 반환)
    let txcount = await this.web3.eth.getTransactionCount(account); //해당 계정의 거래 횟수
    console.log(account);
    console.log(balance);
    //화면에 표시
    $('#show1').text(account);
    $('#show2').text(balance);
    $('#show3').text(txcount);
  },
}; // App의 끝.

//문서가 준비되면 실행되는 문구
//웹 페이지의 DOM이 완전히 로드된 후 App.initWeb3()를 실행함
$(function () {
  App.initWeb3();
  //Web3 객체가 정상적으로 초기화되었다면
  if (App.web3) {
    //다음 함수를 통해 계정 정보를 화면에 출력
    App.showAccountInfo();

    // 사용자가 메타마스크에서 다른 계정을 선택할 경우 현재 페이지 새로고침하여 최신 계정 정보로 갱신
    window.ethereum.on('accountsChanged', function () {
      location.reload();
    });
  }
});
