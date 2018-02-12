package com.xinyi.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.xinyi.dao.EmpDao;
import com.xinyi.entity.Emp;
import com.xinyi.mapper.EmpMapper;

@Component("empService")
public class EmpService {
	//@Resource(name="empDao")
	//private EmpDao empDao;
	@Resource(name="empMapper")
	private EmpMapper empDao;
	
	public Emp query(Integer empno){
		return empDao.query(empno);
	}
	public List<Emp> queryAll(){
		return empDao.queryAll();
	}
	//难道要这样传入每一个字段
	public void insert(
			Integer empno
			,String ename
			,String job
			,Integer mgr
			,java.util.Date hiredate
			,Double sal
			,Double comm
			,Integer deptno
			){
		empDao.insert(empno, ename, job, mgr, hiredate, sal, comm, deptno);
	}
	public void delete(Integer empno){
		empDao.delete(empno);
	}
	public void update(
			Integer empno
			,String ename
			,String job
			,Integer mgr
			,java.util.Date hiredate
			,Double sal
			,Double comm
			,Integer deptno
			){
		empDao.update(empno, ename, job, mgr, hiredate, sal, comm, deptno);
	}
}
