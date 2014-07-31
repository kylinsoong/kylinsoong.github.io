---
layout: blog
title:  "Highlighting code snippets"
date:   2014-07-22 17:57:12
categories: jekyll
author: Kylin Soong
duoshuoid: ksoong20140722
---

Jekyll also has built-in support for syntax highlighting of code snippets using either Pygments or Rouge, and including a code snippet in any post is easy. Below contain a list of samples for highlighting code snippets:

{% highlight ruby %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}

{% highlight java linenos %}
private static final String JDBC_DRIVER = "org.teiid.jdbc.TeiidDriver";
private static final String JDBC_URL = "jdbc:teiid:Marketdata@mm://localhost:31000;version=1";
private static final String JDBC_USER = "user";
private static final String JDBC_PASS = "user";
{% endhighlight %}

{% highlight xml %}
<model name="Stocks" type="VIRTUAL">
        <metadata type="DDL"><![CDATA[
CREATE VIEW Marketdata(
symbol string,
price bigdecimal
)
AS
SELECT
A.SYMBOL, A.PRICE
FROM
(EXEC MarketData.getTextFiles('marketdata.csv')) AS f, TEXTTABLE(f.file COLUMNS SYMBOL string, PRICE bigdecimal HEADER) AS A;

CREATE VIEW Stock(
product_id long,
symbol string,
price bigdecimal,
company_name varchar(256)
)
AS
SELECT A.ID, S.symbol, S.price, A.COMPANY_NAME FROM Marketdata AS S, PRODUCT AS A WHERE S.symbol = A.SYMBOL;
]]> </metadata>
    </model>
{% endhighlight %}
