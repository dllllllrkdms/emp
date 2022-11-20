package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인
	// innerjoin 결과를 처리할 수가 없다
	//public int empNo;
	//public String deptNo;
	
	// dept_emp테이블의 행뿐만 아니라 JOIN 결과 처리가능
	// 복잡하다
	private Employee emp;
	private Department dept;
	private String fromDate;
	private String toDate;
	public Employee getEmp() {
		return emp;
	}
	public void setEmp(Employee emp) {
		this.emp = emp;
	}
	public Department getDept() {
		return dept;
	}
	public void setDept(Department dept) {
		this.dept = dept;
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
