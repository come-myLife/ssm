package com.wen.service;

import com.wen.dao.BookMapper;
import com.wen.pojo.Books;

import java.util.List;
//业务层调dao层
public class BookServiceImpl implements BookService{
    //调用dao层的操作，设置一个set接口，方便Spring管理

    private BookMapper bookMapper;

    public void setBookMapper(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    public int addBook(Books book) {
        return bookMapper.addBook(book);
    }

    public int deleteBookById(int id) {
        return bookMapper.deleteBookById(id);
    }

    public int updateBook(Books book) {
        return bookMapper.updateBook(book);
    }

    public Books queryBookById(int id) {
        return bookMapper.queryBookById(id);
    }

    public void deleteID() {
    }

    @Override
    public List<Books> queryAllBook() {
        return bookMapper.queryAllBook();
    }

    @Override
    public Books queryBookByName(String BookName) {
        return bookMapper.queryBookByName(BookName);
    }


    public List<Books> queryBookByHhName(String bookName) {
        return bookMapper.queryBookByHhName(bookName);
    }


}
