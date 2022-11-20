package vo;

public class Employee {
	// 2. model (모델 데이터 생성)
	// 정보은닉 -> getter setter 메서드
	// public(100% 오픈) < protected(동일패키지, 하위클래스) < default(하위클래스) < private(클래스내부에서만)
	private int empNo; 
	private String birthDate;
	private String firstName;
	private String lastName;
	private String gender;
	private String hireDate;
	// 캡슐화 getter setter 메서드로 클래스 외부에서도 사용가능하게.
	public int getEmpNo() {
		return empNo;
	}
	public void setEmpNo(int empNo) {
		this.empNo = empNo;
	}
	public String getBirthDate() {
		return birthDate;
	}
	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getHireDate() {
		return hireDate;
	}
	public void setHireDate(String hireDate) {
		this.hireDate = hireDate;
	}
}
