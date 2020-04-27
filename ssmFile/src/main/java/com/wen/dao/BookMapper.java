package com.wen.dao;

import com.wen.pojo.Books;

import java.util.List;

public interface BookMapper {
    //增加一本书
    int addBook(Books book);
    //删除一本书
    int deleteBookById( int id);
    //更新一本书
    int updateBook(Books book);
    //查询一本书
    Books queryBookById( int id);
    //查询所有的书（分页）
    int queryBookCount();

    //解决删除书籍，id没有连续的问题（需要放到插入前，不能放到删除以后）
    void deleteID();

    List<Books> queryAllBook();
    //查询书籍根据书名
    Books queryBookByName(String BookName);

    //模糊查询书籍（根据书名）
    List<Books> queryBookByHhName(String bookName);
}
