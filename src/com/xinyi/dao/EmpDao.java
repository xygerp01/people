package com.xinyi.dao;

import java.util.List;

import com.xinyi.entity.Emp;

public interface EmpDao {
	public Emp query(Integer empno);//难道每个查询条件都要写一个？？？
	public List<Emp> queryAll();
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
			);
	public void delete(Integer empno);
	public void update(
			Integer empno
			,String ename
			,String job
			,Integer mgr
			,java.util.Date hiredate
			,Double sal
			,Double comm
			,Integer deptno
			);
}