package com.xinyi.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Component;

import com.xinyi.dao.EmpDao;
import com.xinyi.entity.Emp;

//写这个太麻烦
//怎么实现无连接下的锁定
//@Component("empDao")
public class EmpDaoImpl implements EmpDao{
	//@Resource(name="jdbcTemplate")
	private JdbcTemplate jdbcTemplate;
	
	public Emp query(Integer empno) {
		Emp emp;
		emp=jdbcTemplate.query(
				"select * from XYG_EMP_V where empno=?"
				, new Object[]{empno}
				, new ResultSetExtractor<Emp>(){
					public Emp extractData(ResultSet rs) throws SQLException,DataAccessException {
						Emp e=new Emp();
						if (rs.next()){
							e.setEmpno(rs.getInt("empno"));
							e.setEname(rs.getString("ename"));
							e.setJob(rs.getString("job"));
							e.setMgr(rs.getInt("mgr"));
							e.setHiredate(rs.getDate("hiredate"));
							e.setSal(rs.getDouble("sal"));
							e.setComm(rs.getDouble("comm"));
							e.setDeptno(rs.getInt("deptno"));
							e.setDname(rs.getString("dname"));
							e.setLoc(rs.getString("loc"));
						}
						return e;
					}
				}
		);
		
		return emp;
	}

	public List<Emp> queryAll() {
		List<Emp> list=new ArrayList<Emp>();
		
		list=jdbcTemplate.query(
				"select * from XYG_EMP_V"
				, new ResultSetExtractor<List<Emp>>(){
					public List<Emp> extractData(ResultSet rs) throws SQLException,DataAccessException {
						List<Emp> l = new ArrayList<Emp>();
						while (rs.next()){
							Emp e=new Emp();
							e.setEmpno(rs.getInt("empno"));
							e.setEname(rs.getString("ename"));
							e.setJob(rs.getString("job"));
							e.setMgr(rs.getInt("mgr"));
							e.setHiredate(rs.getDate("hiredate"));
							e.setSal(rs.getDouble("sal"));
							e.setComm(rs.getDouble("comm"));
							e.setDeptno(rs.getInt("deptno"));
							e.setDname(rs.getString("dname"));
							e.setLoc(rs.getString("loc"));
							l.add(e);
						}
						return l;
					}
				}
		);
		
		return list;
	}

	public void insert(Integer empno, String ename, String job, Integer mgr,
			Date hiredate, Double sal, Double comm, Integer deptno) {
		jdbcTemplate.update(
				"inset into emp(empno,ename,job,mgr,hiredate,sal,comm,deptno) values (?,?,?,?,?,?,?,?)"
				, new Object[]{empno,ename,job,mgr,hiredate,sal,comm,deptno}
		);
	}

	public void delete(Integer empno) {
		jdbcTemplate.update(
				"delete emp where empno=?"
				,new Object[]{empno}
		);
	}

	@Override
	public void update(Integer empno, String ename, String job, Integer mgr,
			Date hiredate, Double sal, Double comm, Integer deptno) {
		jdbcTemplate.update(
				"update emp set ename=?,job=?,mgr=?,hiredate=?,sal=?,comm=?,deptno=? where empno=?"
				,new Object[]{ename,job,mgr,hiredate,sal,comm,deptno,empno}
		);
	}
}
