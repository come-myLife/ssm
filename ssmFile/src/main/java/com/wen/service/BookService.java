package com.wen.service;

import com.wen.pojo.Books;

import java.util.List;

public interface BookService {

    //增加一本书
    int addBook(Books book);
    //删除一本书
    int deleteBookById( int id);
    //更新一本书
    int updateBook(Books book);
    //查询一本书
    Books queryBookById( int id);
    //解决删除书籍，id没有连续的问题
    void deleteID();
    //查询所有的书
    List queryAllBook();
    //查询书籍（根据书名）
    Books queryBookByName(String BookName);

    //模糊查询书籍（根据书名）
    List<Books> queryBookByHhName(String bookName);
}
