package vo;

public class Salary {
	//public int empNo;
	private Employee emp; // 2) salaries 테이블과 employees 테이블을 (외래키 emp_no)로 이어진 inner join 한 결과물을 저장하기 위해 
	private int salary;
	private String fromDate;
	private String toDate;
	// 캡슐화
	public Employee getEmp() {
		return emp;
	}
	public void setEmp(Employee emp) {
		this.emp = emp;
	}
	public int getSalary() {
		return salary;
	}
	public void setSalary(int salary) {
		this.salary = salary;
	}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
	}
}
