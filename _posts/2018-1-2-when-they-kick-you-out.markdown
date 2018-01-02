---
layout: post
title:  "when they kick you out"
date:   2018-01-02 11:11:00 +1100
categories: german
---
wenn sie dich rausschmeißen
{% highlight ruby%}
2.3.4 :001 > require 'date'
=> true

2.3.4 :002 > arrived_on = Date.parse('14-12-2017')
=> #<Date: 2017-12-14 ((2458102j,0s,0n),+0s,2299161j)>

2.3.4 :003 > visa_expires = arrived_on+90
=> #<Date: 2018-03-14 ((2458192j,0s,0n),+0s,2299161j)>

2.3.4 :004 > visa_expires.to_s
=> "2018-03-14"

{% endhighlight %}
