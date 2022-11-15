package vo;

public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인
	// innerjoin 결과를 처리할 수가 없다
	//public int empNo;
	//public String deptNo;
	
	// dept_emp테이블의 행뿐만 아니라 JOIN 결과 처리가능
	// 복잡하다
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
}
