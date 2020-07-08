# part zero, the extension method


# part one, the Enumerable

linq depends on the IEnumerable<T> interface. If I look at for example linqs select method signature
{% highlight c# %}
public static IEnumerable<TResult> Select<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector);
{% endhighlight %}
I can see that it is an extension method for the type IEnumerable<TSource>
 
