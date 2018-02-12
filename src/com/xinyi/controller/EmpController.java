package com.xinyi.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xinyi.entity.Emp;
import com.xinyi.service.EmpService;

@Controller
@RequestMapping("/emp")
public class EmpController {
	@Resource(name="empService")
	private EmpService empService;
	public HttpServletResponse res;
	
	//进入员工资料表
	@RequestMapping("/queryAll")
	public String queryAll(Map<String,Object> model){
		List list;
		list=empService.queryAll();
		model.put("list",list);
		
		return "empQueryAll";
	}
	
	//点编辑进入员工
	@RequestMapping("/edit")
	public String edit(Integer empno,Map<String,Object> model){
		Emp emp;
		emp=empService.query(empno);
		model.put("emp",emp);
		
		return "empEdit";
	}
	
	//点删除
	@RequestMapping("/delete")
	public String delete(Integer empno){
		empService.delete(empno);
		
		return "redirect:/emp/queryAll";
	}
	
	//点新增进入员工
	@RequestMapping("/add")
	public String add(){
		return "empEdit";
	}
	
	@RequestMapping("/insert")
	@ResponseBody
	public String insert(Emp emp) throws Exception{
		empService.insert(emp.getEmpno()
						, emp.getEname()
						, emp.getJob()
						, emp.getMgr()
						, emp.getHiredate()
						, emp.getSal()
						, emp.getComm()
						, emp.getDeptno()
						);
		//String result = "[{\"res\":1}]";
		//String result = "{\"res\": 2}";
		//response.getWriter().print(result);
		return "none";
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(Integer empno
			,String ename
			,String job
			,Integer mgr
			,java.util.Date hiredate
			,Double sal
			,Double comm
			,Integer deptno){
		empService.update(empno, ename, job, mgr, hiredate, sal, comm, deptno);
		return "none";
	}
}
