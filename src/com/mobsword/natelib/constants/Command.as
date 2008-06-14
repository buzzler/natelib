package com.mobsword.natelib.constants
{
	/**
	* ...
	* @author Default
	*/
	public class Command
	{
		/**
		 * 프로토콜 버전
		 */
		public	static const PVER	:String = 'PVER';
		
		/**
		 * 인증 방식 (DES Authentication)
		 */
		public	static const AUTH	:String = 'AUTH';
		
		/**
		 * 접속 세션 요청. 대화 세션과 다르다.
		 */
		public	static const REQS	:String = 'REQS';
		
		/**
		 * 비밀번호 확인 및 사용자 정보
		 */
		public	static const LSIN	:String = 'LSIN';
		
		/**
		 * 환경 설정값. 싸이월드나 네이트온 메신저에 필요한 기타 정보들
		 */
		public	static const CONF	:String = 'CONF';
		
		/**
		 * 친구 목록 & 친구정보
		 */
		public	static const LIST	:String = 'LIST';
		
		/**
		 * 접속자 상태
		 */
		public	static const INFY	:String = 'INFY';
		
		/**
		 * 접속자 상태 변경
		 */
		public	static const NTFY	:String = 'NTFY';
		
		/**
		 * 그룹 목록 & 그룹 정보
		 */
		public	static const GLST	:String = 'GLST';
		
		/**
		 * 계정 상태 변경
		 */
		public	static const ONST	:String = 'ONST';
		
		/**
		 * 계정 대화명 변경
		 */
		public	static const CNIK	:String = 'CNIK';
		
		/**
		 * 친구 대화명 변경 알림
		 */
		public	static const NNIK	:String = 'NNIK';
		
		/**
		 * 그룹추가
		 */
		public	static const ADDG	:String = 'ADDG';

		public	static const NPRF	:String = 'NPRF';
		
		/**
		 * 그룹명 변경
		 */
		public	static const RENG	:String = 'RENG';
		
		/**
		 * 그룹 삭제
		 */
		public	static const RMVG	:String = 'RMVG';
		
		/**
		 * 친구 요청
		 */
		public	static const ADSB	:String = 'ADSB';
		
		/**
		 * 친구 리스트 추가
		 */
		public	static const ADDB	:String = 'ADDB';
		
		/**
		 * 친구 리스트 삭제
		 */
		public	static const RMVB	:String = 'RMVB';
		
		/**
		 * 대화 세션 요청
		 */
		public	static const RESS	:String = 'RESS';
		
		/**
		 * 연결 확인
		 */
		public	static const PING	:String = 'PING';
		
		/**
		 * 강제 종료
		 */
		public	static const KILL	:String = 'KILL';
		
		/**
		 * 세션 입장
		 */
		public	static const ENTR	:String = 'ENTR';
		
		/**
		 * Client to Client (?)
		 * 
		 * payload메시지이다. 세션 초대와 같은 메시지는 byte array에 담아서 CTOC로 전달한다.
		 */
		public	static const CTOC	:String = 'CTOC';
		
		/**
		 * 세션 초대
		 * payload 커맨드에 담겨서 전송된다.
		 */
		public	static const INVT	:String = 'INVT';
		
		/**
		 * 세션 참가
		 */
		public	static const JOIN	:String = 'JOIN';
		
		/**
		 * 세션 참가자 (Attendies)
		 */
		public	static const USER	:String = 'USER';
		
		/**
		 * 세션 메시지
		 */
		public	static const MESG	:String = 'MESG';
		
		/**
		 * 세션 참가자의 타이핑 상태
		 * 세션 메시지 커맨드의 type중 하나이다.
		 * 
		 * @see MESG
		 */
		public	static const TYPING	:String = 'TYPING';
		
		/**
		 * 세션 참가자가 보낸 메시지 본문
		 * 세션 메시지 커맨드의 type중 하나이다.
		 * 
		 * @see MESG
		 */
		public	static const MSG	:String = 'MSG';
		
		/**
		 * 세션 참가자가 보낸 메시지에 사용된 이모티콘 정보
		 * 세션 메시지 커맨드의 type중 하나이다.
		 * 
		 * @see MESG
		 */
		public	static const EMOTICON:String = 'EMOTICON';

		/**
		 * 세션 참가자의 메신저 설정
		 */
		public	static const WHSP	:String = 'WHSP';
		
		/**
		 * 세션 참가자의 프로필 이미지 정보
		 * WHSP 커맨드의 type중 하나이다.
		 * 
		 * @see WHSP
		 */
		public	static const DPIMG	:String = 'DPIMG';
		
		/**
		 * 세션 참가자의 화상 대화기능 여부
		 * WHSP 커맨드의 type중 하나이다.
		 * 
		 * @see WHSP
		 */
		public	static const AVCHAT2:String = 'AVCHAT2';
		
		/**
		 * 세션 참가자의 폰트 정보
		 * WHSP 커맨드의 type중 하나이다.
		 * 
		 * @see WHSP
		 */
		public	static const FONT	:String = 'FONT';
		
		/**
		 * 세션 종료
		 */
		public	static const QUIT	:String = 'QUIT';
	}
	
}