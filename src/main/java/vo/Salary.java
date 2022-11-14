package vo;

public class Salary {
	//public int empNo;
	public Employee emp; // 2) salaries 테이블과 employees 테이블을 (외래키 emp_no)로 이어진 inner join 한 결과물을 저장하기 위해 
	public int salary;
	public String fromDate;
	public String toDate;
}
