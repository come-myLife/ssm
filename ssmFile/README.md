# SSM框架整合
回顾了下Spring,SpringMVC,MyBatis框架整合，完善了一个小案例，包括基本的增删改查功能。
#### 环境要求

- IDEA
- MySQL 
- Tomcat
- Maven  
- 需要熟练掌握MySQL数据库，Spring，JavaWeb及MyBatis知识，简单的前端知识；

#### 数据库环境

创建一个存放书籍书籍的数据库表

```sql
CREATE DATABASE `ssmbuild`;

USE `ssmbuild`;

DROP TABLE IF EXISTS `books`;

CREATE TABLE `books` (
  `bookID` INT(10) NOT NULL AUTO_INCREMENT COMMENT '书id',
  `bookName` VARCHAR(100) NOT NULL COMMENT '书名',
  `bookCounts` INT(11) NOT NULL COMMENT '数量',
  `detail` VARCHAR(200) NOT NULL COMMENT '描述',
  KEY `bookID` (`bookID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT  INTO `books`(`bookID`,`bookName`,`bookCounts`,`detail`)VALUES 
(1,'Java',1,'从入门到放弃'),
(2,'MySQL',10,'从删库到跑路'),
(3,'Linux',5,'从进门到进牢');
```

#### 基本环境搭建

1. 新建一Maven项目！ ssmbuild ， 添加web的支持
2. 导入相关的pom依赖！

```xml
  <dependencies>
        <!--Junit-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <!--数据库驱动-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.19</version>
        </dependency>
        <!-- 数据库连接池 -->
        <dependency>
            <groupId>com.mchange</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.5.2</version>
        </dependency>
        <!--Servlet - JSP -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
        <!--Mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.2</version>
        </dependency>
        <!--Spring-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
    <!-- lombok-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.8</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
```

3. Maven资源过滤设置 

```xml
<build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
        </resources>
    </build>
```

4. **建立基本结构和配置框架**

- com.wen.pojo

- com.wen.dao

- com.wen.service

- com.wen.controller
 
resource

- applicationContext.xml

- database.properties

- mybatis-config.xml

- spring-dao.xml

- spring-mvc.xml

- spring-service.xml

webapp

- web.xml

- 和一些资源文件

#### Mybatis层编写

1. 数据库配置文件 database.properties

   ```properties
   jdbc.driver=com.mysql.jdbc.Driver
   # 如果使用的是MySQL8.0+ ，增加一个时区的配置
   jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8&serverTimezone=UTC
   jdbc.username=root
   jdbc.password=root2019   
   ```

2. IDEA 关联数据库

    **注意点**
    - 如果关联的是mysql数据库就一定要看一下有没有mysql环境打开cmd直接输入mysql，如果
    提示的不是你的mysql版本就说明你没有配置，配置的时候就尽量加上自己的时区，好像说5点几的
    可以不用，但是mysql版本可以向下兼容的，多一步也没事

3. 编写MyBatist的核心配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE configuration
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-config.dtd">
   <configuration>
   
       <!--控制台输出sql-->
       <settings>
           <setting name="logImpl" value="STDOUT_LOGGING"/>
       </settings>
   
       <!--配置数据源  交给spring去做-->
       <typeAliases>
           <package name="com.wen.pojo"/>
       </typeAliases>
   
       <!--分页-->
       <plugins>
           <!-- com.github.pagehelper为PageInterceptor类所在包名 -->
           <plugin interceptor="com.github.pagehelper.PageInterceptor">
               <!-- 该参数默认为false -->
               <!-- 设置为true时，会将RowBounds第一个参数offset当成pageNum页码使用 -->
               <!-- 和startPage中的pageNum效果一样 -->
               <property name="offsetAsPageNum" value="true" />
               <!-- 该参数默认为false -->
               <!-- 设置为true时，使用RowBounds分页会进行count查询 -->
               <property name="rowBoundsWithCount" value="true" />
               <!-- 设置为true时，如果pageSize=0或者RowBounds.limit = 0就会查询出全部的结果 -->
               <!-- （相当于没有执行分页查询，但是返回结果仍然是Page类型） -->
               <property name="pageSizeZero" value="true" />
               <!-- 3.3.0版本可用 - 分页参数合理化，默认false禁用 -->
               <!-- 启用合理化时，如果pageNum<1会查询第一页，如果pageNum>pages会查询最后一页 -->
               <!-- 禁用合理化时，如果pageNum<1或pageNum>pages会返回空数据 -->
               <property name="reasonable" value="false" />
               <!-- 3.5.0版本可用 - 为了支持startPage(Object params)方法 -->
               <!-- 增加了一个`params`参数来配置参数映射，用于从Map或ServletRequest中取值 -->
               <!-- 可以配置pageNum,pageSize,count,pageSizeZero,reasonable,不配置映射的用默认值 -->
               <!-- 不理解该含义的前提下，不要随便复制该配置 -->
               <property name="params" value="pageNum=start;pageSize=limit;" />
               <!-- always总是返回PageInfo类型,check检查返回类型是否为PageInfo,none返回Page -->
               <property name="returnPageInfo" value="check" />
           </plugin>
       </plugins>
       <mappers>
           <mapper class="com.wen.dao.BookMapper"/>
       </mappers>
   
   </configuration>
   ```

4. 编写数据库对应的实体类com.wen.pojo.Books(使用lombok插件)

   ```java
   package com.wen.pojo;
   
   import lombok.AllArgsConstructor;
   import lombok.Data;
   import lombok.NoArgsConstructor;
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   public class Books {
       private int bookId;
       private String bookName;
       private int bookCounts;
       private String detail;
   }
   ```

5. **编写Dao层的Mapper接口：BookMapper**

   ```java
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
   ```

6. 编写接口对应的Mapper.xml文件：BookMapper.xml。需要导入MyBatis的包

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="com.wen.dao.BookMapper">
   
       <insert id="addBook" parameterType="Books">
           insert into ssmbuild.books(bookName,bookCounts,detail)
           values (#{bookName},#{bookCounts},#{detail})
       </insert>
   
       <delete id="deleteBookById" parameterType="int">
           delete from ssmbuild.books where bookID = #{bookId}
       </delete>
       <delete id="deleteID">
           ALTER TABLE ssmbuild.books AUTO_INCREMENT = 1
       </delete>
   
       <update id="updateBook" parameterType="Books">
           update ssmbuild.books set bookName = #{bookName},bookCounts = #{bookCounts},detail=#{detail}
           where bookID = #{bookId}
       </update>
   
       <select id="queryBookById" resultType="Books">
           select * from ssmbuild.books where bookID = #{bookId}
       </select>
   
       <select id="queryBookCount"  resultType="int">
           select count(*) from ssmbuild.books
       </select>
   
       <select id="queryAllBook" resultType="com.wen.pojo.Books">
          select * from ssmbuild.books
       </select>
   
       <select id="queryBookByName"  resultType="Books">
           select * from ssmbuild.books where bookName=#{bookName}
       </select>
   
       <select id="queryBookByHhName"  resultType="Books">
           select * from ssmbuild.books
           <where>
               <if test="bookName != null and bookName != ''">
                   bookName like concat('%',#{bookName},'%')
               </if>
           </where>
       </select>
   
       <select id="queryBookCountByName"  resultType="int">
           select count(*) from ssmbuild.books
            where bookName like "%"#{bookName}"%";
       </select>
   
   </mapper>
   ```

7. **编写Service层的接口和实现类：**

   BookService接口：

   ```java
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

   ```

   BookServiceImpl实现类：

   ```java
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
   ```

#### Spring层  

1. 配置**Spring整合MyBatis**，我们这里数据源使用c3p0连接池；

2. 编写Spring整合Mybatis的相关的配置文件：spring-dao.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:aop="http://www.springframework.org/schema/aop"
          xmlns:tx="http://www.springframework.org/schema/tx"
          xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="
      http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
      http://www.springframework.org/schema/aop
      http://www.springframework.org/schema/aop/spring-aop-3.0.xsd
      http://www.springframework.org/schema/tx
      http://www.springframework.org/schema/tx/spring-tx-3.0.xsd
      http://www.springframework.org/schema/context     
      http://www.springframework.org/schema/context/spring-context-3.0.xsd">
       <!--    关联数据库配置文件-->
       <context:property-placeholder location="classpath:database.properties"/>
   
       <!--    连接池
           dbcp
           c3p0
           druid
            hikari-->
       <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
           <property name="driverClass" value="${jdbc.driver}"></property>
           <property name="jdbcUrl" value="${jdbc.url}"></property>
           <property name="user" value="${jdbc.username}"></property>
           <property name="password" value="${jdbc.password}"></property>
           <!-- c3p0连接池的私有属性 -->
           <property name="maxPoolSize" value="30"/>
           <property name="minPoolSize" value="10"/>
           <!-- 关闭连接后不自动commit -->
           <property name="autoCommitOnClose" value="false"/>
           <!-- 获取连接超时时间 -->
           <property name="checkoutTimeout" value="10000"/>
           <!-- 当获取连接失败重试次数 -->
           <property name="acquireRetryAttempts" value="2"/>
   
       </bean>
       <!--    sqlSessionFactory-->
       <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
           <!-- 注入数据库连接池 -->
           <property name="dataSource" ref="dataSource"/>
           <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
           <property name="configLocation" value="classpath:mybatis-config.xml"/>
       </bean>
   
       <!-- 4.配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
       <!--解释 ： https://www.cnblogs.com/jpfss/p/7799806.html-->
       <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
           <!-- 注入sqlSessionFactory -->
           <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
           <!-- 给出需要扫描Dao接口包 -->
           <property name="basePackage" value="com.wen.dao"/>
       </bean>
   </beans>
   ```

3. Spring整合service层 spring-service.xml
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:aop="http://www.springframework.org/schema/aop"
          xmlns:tx="http://www.springframework.org/schema/tx"
          xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="
      http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
      http://www.springframework.org/schema/aop
      http://www.springframework.org/schema/aop/spring-aop-3.0.xsd
      http://www.springframework.org/schema/tx
      http://www.springframework.org/schema/tx/spring-tx-3.0.xsd
      http://www.springframework.org/schema/context
      http://www.springframework.org/schema/context/spring-context-3.0.xsd">
       <!--BookServiceImpl注入到IOC容器中-->
       <bean id="BookServiceImpl" class="com.wen.service.BookServiceImpl">
           <property name="bookMapper" ref="bookMapper"/>
       </bean>
       <!-- 扫描service相关的bean -->
       <context:component-scan base-package="com.wen.service"/>
       <!-- 配置事务管理器 -->
       <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
           <!-- 注入数据库连接池 -->
           <property name="dataSource" ref="dataSource" />
       </bean>
   </beans>
   ```
4. Spring整合service层 spring-mvc.xml   
    ```xml
   <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:aop="http://www.springframework.org/schema/aop"
           xmlns:tx="http://www.springframework.org/schema/tx"
           xmlns:context="http://www.springframework.org/schema/context"
           xmlns:mvc="http://www.springframework.org/schema/mvc"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop-3.0.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx-3.0.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context-3.0.xsd http://www.springframework.org/schema/mvc https://www.springframework.org/schema/mvc/spring-mvc.xsd">
    
    
        <!-- 配置SpringMVC -->
        <!-- 1.开启SpringMVC注解驱动 -->
        <mvc:annotation-driven />
        <!-- 2.静态资源默认servlet配置-->
        <mvc:default-servlet-handler/>
    
        <!-- 3.配置jsp 显示ViewResolver视图解析器 -->
        <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
            <property name="viewClass" value="org.springframework.web.servlet.view.JstlView" />
            <property name="prefix" value="/WEB-INF/jsp/" />
            <property name="suffix" value=".jsp" />
        </bean>
    
        <!-- 4.扫描web相关的bean -->
        <context:component-scan base-package="com.wen.controller" />
    </beans>
    ```

#### SpringMVC层

1. 项目添加框架支持Web，修改WEB-INF文件下web.xml文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
   
     <!--DispatcherServlet-->
     <servlet>
       <servlet-name>DispatcherServlet</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
       <init-param>
         <param-name>contextConfigLocation</param-name>
         <param-value>classpath:applicationContext.xml</param-value>
       </init-param>
       <load-on-startup>1</load-on-startup>
     </servlet>
     <servlet-mapping>
       <servlet-name>DispatcherServlet</servlet-name>
       <url-pattern>/</url-pattern>
     </servlet-mapping>
   
     <!--encodingFilter-->
     <filter>
       <filter-name>encodingFilter</filter-name>
       <filter-class>
         org.springframework.web.filter.CharacterEncodingFilter
       </filter-class>
       <init-param>
         <param-name>encoding</param-name>
         <param-value>utf-8</param-value>
       </init-param>
     </filter>
     <filter-mapping>
       <filter-name>encodingFilter</filter-name>
       <url-pattern>/*</url-pattern>
     </filter-mapping>
   
     <!--Session过期时间-->
     <session-config>
       <session-timeout>15</session-timeout>
     </session-config>
   </web-app>
   ```


2. Spring配置整合文件：applicationContext.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="
      http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
   
   
       <import resource="classpath:spring-dao.xml"></import>
       <import resource="classpath:spring-service.xml"></import>
       <import resource="classpath:spring-mvc.xml"></import>
   
   </beans>
   ```

   

#### Conntroller 和 视图

1. BookController 类编写 。 方法一：查询全部书籍

   ```java
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

   ```

2. 编写首页：index.jsp 

   ```html
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   <html>
   <head>
       <meta charset="UTF-8">
       <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="icon" href="https://www.naqub.cn/wp-content/uploads/2018/12/cropped-ico-32x32.png" sizes="32x32">
       <title>login</title>
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.css">
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.css">
       <script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/quietflow.min.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.js"></script>
       <link href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/logincss.css" rel="stylesheet">
       <style type="text/css">
           a {
               text-decoration: none;
               color: black;
               font-size: 18px;
           }
           h3 {
               width: 180px;
               height: 38px;
               margin: 190px auto;
               text-align: center;
               line-height: 38px;
               background: deepskyblue;
               border-radius: 4px;
           }
       </style>
   </head>
   <body>
   <h3>
       <a href="${pageContext.request.contextPath}/book/allBook">进入书籍页面</a>
   </h3>
   
   <h3>
       <a href="">登陆</a>
   </h3>
   </body>
   </html>
   ```

3. 编写书籍列表页：allBook.jsp

   ```html
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
   <html>
   <head>
       <title>书籍列表</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
       <meta charset="UTF-8">
       <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="icon" href="https://www.naqub.cn/wp-content/uploads/2018/12/cropped-ico-32x32.png" sizes="32x32">
       <title>login</title>
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.css">
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.css">
       <script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/quietflow.min.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.js"></script>
       <link href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/logincss.css" rel="stylesheet">
       <style>
               .box{
                   width: 50%;
                   margin: 0px auto;
                   border-radius: 10px;
               }
               .img-box{
                   width: 100%;
                   position:relative;
                   z-index:1;
                   border-radius: 10px;
               }
               .img-box img{
                   position:absolute;
                   top:0;
                   bottom:0;
                   left:0;
                   right:0;
                   border-radius: 10px;
                   width:100%;
                   margin:auto;
                   z-index: -1;
                   *zoom:1;
               }
               .img-box:before {
                   content: "";
                   display: inline-block;
                   padding-bottom: 55%;
                   width: 0.1px;	/*必须要有数值，否则无法把高度撑起来*/
                   vertical-align: middle;
               }
       </style>
   </head>
   
   <body ondragstart="return false;"><%--禁止鼠标拖动产生新的页面--%>
   
   <div class="container">
   
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>书籍列表 —— 显示所有书籍</small>
                   </h1>
   
               </div>
           </div>
       </div>
   
       <div class="row">
           <div class="col-md-9 column">
               <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/toaddBook">新增</a>
               <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook">显示所有书籍</a>
               <span style="color: red">${error}</span>
           </div>
           <div class="col-md-3 column">
               <form action="${pageContext.request.contextPath}/book/queryBook" method="" >
                   <div class="input-group">
                       <input type="text" name="queryBookName" class="form-control" placeholder="请输入要查找的书籍">
                       <span class="input-group-btn">
                           <button class="btn btn-primary" type="submit">查询</button>
                           </span>
                   </div><!-- /input-group -->
               </form>
           </div>
       </div>
   
       <div class="row clearfix">
           <div class="col-md-12 column">
               <table class="table table-hover table-striped">
                   <thead>
                   <tr>
                       <th>书籍编号</th>
                       <th>书籍名字</th>
                       <th>书籍数量</th>
                       <th>书籍详情</th>
                       <th>操作</th>
                   </tr>
                   </thead>
                   <tbody>
                   <c:if test="${not empty list}">
                       <c:forEach var="book" items="${list}">
                           <tr>
                               <td>${book.bookId}</td>
                               <td>${book.bookName}</td>
                               <td>${book.bookCounts}</td>
                               <td>${book.detail}</td>
                               <td>
                                   <a href="${pageContext.request.contextPath}/book/toUpdateBook?id=${book.bookId}">更改</a> |
                                   <a href="${pageContext.request.contextPath}/book/deleteBook?id=${book.bookId}">删除</a>
                               </td>
                           </tr>
                       </c:forEach>
                   </c:if>
                   </tbody>
               </table>
               <c:if test="${empty list}">
               <div class="box">
                   <div class="img-box">
                       <img src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/medias/dwrgIMG/8.jpg"/>
                           <span style="margin-left: 260px">一本都没有了</span>
                   </div>
               </div>
               </c:if>
               <div style="margin:auto 0">
   
                   <h1>${page.}</h1>
                   <div style="position: relative;top: 50px;left: 500px">
                       <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateFirstPage}">首页</a>
                       <c:if test="${page.pageNum>1
   
                       }">
                           <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.prePage}">上一页</a>
                       </c:if>
                       <c:if test="${page.pageNum<page.nextPage}">
                           <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.nextPage}">下一页</a>
                           <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateLastPage}">尾页</a>
                       </c:if>
                       <c:if test="${page.pageNum!=0&&page.pageNum==2}">
                           <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateLastPage}">尾页</a>
                       </c:if>
                   </div>
               </div>
           </div>
       </div>
   </div>
   ```

4. 编写添加书籍页面：addBook.jsp

   ```html
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   
   <html>
   <head>
       <title>新增书籍</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
       <title>书籍列表</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
       <meta charset="UTF-8">
       <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="icon" href="https://www.naqub.cn/wp-content/uploads/2018/12/cropped-ico-32x32.png" sizes="32x32">
       <title>login</title>
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.css">
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.css">
       <script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/quietflow.min.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.js"></script>
       <link href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/logincss.css" rel="stylesheet">
   </head>
   <body>
   <div class="container">
   
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>新增书籍</small>
                   </h1>
               </div>
           </div>
       </div>
   
       <form action="${pageContext.request.contextPath}/book/addBook" method="post" style="width: 50%;margin: 80px auto;">
           <div class="form-group">
               <label for="bookName">书籍名称：</label>
               <input type="text" class="form-control" id="bookName" name="bookName" placeholder="书籍名称">
           </div>
           <div class="form-group">
               <label for="bookCounts"> 书籍数量：</label>
               <input type="text" class="form-control" id="bookCounts" name="bookCounts" placeholder="书籍数量">
           </div>
           <div class="form-group">
               <label for="detail"> 书籍详情：</label>
               <input type="text" class="form-control" id="detail" name="detail" placeholder="书籍详情">
           </div>
           <input class="btn btn-primary" type="submit" value="提交"/>
       </form>
   </div>
   </body>
   </html>
   ```

5. 编写修改书籍页面：updateBook.jsp

   ```html
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   
   <html>
   <head>
       <title>修改书籍</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
       <title>书籍列表</title>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 引入 Bootstrap -->
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
       <meta charset="UTF-8">
       <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="icon" href="https://www.naqub.cn/wp-content/uploads/2018/12/cropped-ico-32x32.png" sizes="32x32">
       <title>login</title>
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.css">
       <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.css">
       <script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/quietflow.min.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.js"></script>
       <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.js"></script>
       <link href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/logincss.css" rel="stylesheet">
   </head>
   <body>
   <div class="container">
   
       <div class="row clearfix">
           <div class="col-md-12 column">
               <div class="page-header">
                   <h1>
                       <small>修改书籍</small>
                   </h1>
               </div>
           </div>
       </div>
   
       <form action="${pageContext.request.contextPath}/book/updateBook" method="post" style="width: 50%;margin: 80px auto;">
           <%--前端传递隐藏域--%>
           <%--修改的时候是根据id去修改--%>
           <input type="hidden" name="bookId" value="${book.bookId}"/>
           <div class="form-group">
               <label for="bookName">书籍名称：</label>
               <input type="text" class="form-control" id="bookName" name="bookName" value="${book.bookName}" placeholder="书籍名称">
           </div>
           <div class="form-group">
               <label for="bookCounts"> 书籍数量：</label>
               <input type="text" class="form-control" id="bookCounts" name="bookCounts" value="${book.bookCounts}"
                      placeholder="书籍数量">
           </div>
           <div class="form-group">
               <label for="detail"> 书籍详情：</label>
               <input type="text" class="form-control" id="detail" name="detail" value="${book.detail}" placeholder="书籍详情">
           </div>
           <input class="btn btn-primary" type="submit" value="提交"/>
       </form>
   </div>
   </body>
   </html>
   ```
## 参考资料
[狂神说Java](https://www.bilibili.com/video/av71874024?p=1)   
后期自己完善了分页和模糊查询功能。

   

