package com.wen.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wen.pojo.Books;
import com.wen.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/book")
public class BookController {
    //controller调service层
    @Autowired
    @Qualifier("BookServiceImpl")
    public BookService bookService;

    //查询全部的书籍，并且返回到一个书籍展示页面
    @RequestMapping("/allBook")
    public String list(@RequestParam(defaultValue="1",required=true)Integer pageNum, Model model, HttpServletRequest request){
        PageHelper.startPage(pageNum, 3);
        List<Books> list = bookService.queryAllBook();
        PageInfo<Books> page = new PageInfo<>(list);
        model.addAttribute("page",page);
        model.addAttribute("list",list);
        return "allBook";
    }

    //跳转到增加数据页面
    @RequestMapping("/toaddBook")
    public String toaddBook(){
        return "addBook";
    }
    //添加书籍操作
    @PostMapping("/addBook")
    public String addBook(Books books){
        bookService.addBook(books);
        return "redirect:/book/allBook";//重定向到@RequestMapping("/toaddBook")
    }
    //跳转到修改书籍页面
    @RequestMapping("/toUpdateBook")
    public String toUpdateBook(int id ,Model model){
        Books books = bookService.queryBookById(id);
        model.addAttribute("book",books);
        return "updateBook";
    }
    //修改书籍
    @PostMapping("updateBook")
    public String updateBook(Books book) {
        bookService.updateBook(book);
        return "redirect:/book/allBook";
    }
    //删除书籍
    @RequestMapping("deleteBook")
    public String deleteBook(int id){
        bookService.deleteBookById(id);
        return "redirect:/book/allBook";
    }
    /*//查询书籍
    @RequestMapping("/queryBook")
    public String queryBook(String queryBookName,Model model){
        Books books = bookService.queryBookByName(queryBookName);
        //System.err.println("books====>"+books);
        List<Books> list = new ArrayList<>();
        //System.err.println(queryBookName);//queryBookName名字需要和前台对应，不然一直显示为空
        list.add(books);
        model.addAttribute("list",list);
        return "allBook";
    }*/
    //模糊查询书籍
    @RequestMapping("/queryBook")
    public String queryBook(String queryBookName,Model model){
        List<Books> books = bookService.queryBookByHhName(queryBookName);//模糊查询有可能返回多条数据用list接收
        //System.err.println("books====>"+books);
        System.err.println(queryBookName);//queryBookName名字需要和前台对应，不然一直显示为空
        model.addAttribute("list",books);
        return "allBook";
    }
}
