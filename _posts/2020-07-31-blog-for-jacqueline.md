# a blog for jacqueline 


```python
import numpy as np
```


```python
import math
```


```python
import pandas as pd
```

### types


```python
a_string_type = 'Hello its me, you already know python has types'
a_float_type_1 = 34.4 
a_float_type_2 = 24.4 
a_float_type_3 = 14.4 
```


```python
print(type(a_string_type)) #str
```

    <class 'str'>
    


```python
print(type(a_float_type_1)) #float
```

    <class 'float'>
    


```python
a_float_list = [a_float_type_1, a_float_type_2, a_float_type_3] # we put our floats inside the list
print(type(a_float_list)) # this has the list type
```

    <class 'list'>
    


```python
print(type(a_float_list[0])) # But each element inside list has the float type
```

    <class 'float'>
    

###  series is a type


```python
# now we have put our list inside a series! What is the difference between an array / ndarray and a series?
# A series has an index! usefull for axes!
my_series = pd.Series(a_float_list) # no index is passed, one will be created having values [0, ..., len(data) - 1].
print(type(my_series))
```

    <class 'pandas.core.series.Series'>
    


```python
my_series   # Note that the series is automatically printed for us, even though we dont use the print function
            # pandas is doing some magic here, so we dont have to loop through the series and print each index and element
```




    0    34.4
    1    24.4
    2    14.4
    dtype: float64



### loops are bad, mutation is bad, higher order functions. get more functional 
one aspect of functional programming is working at a higher level of abstraction. We dont want to write a for loop to check the type of each item in our series, that would take many lines. We can do it in a single line


```python
# avoid loops with series, lambdas are a good alternative to apply some function to each values, first lets check 
# the type of our variable to see what we are working with
my_series.apply(lambda x: type(x))
```




    0    <class 'float'>
    1    <class 'float'>
    2    <class 'float'>
    dtype: object



apply is a mapping function that takes a function. This is one kind of higher order function, one more aspect of being functional.

Another aspect of functional programming is not mutating our data. look at the previous cell! we have completly lost our data! but luckily the series has not been overwritten!


```python
my_series
```




    0    34.4
    1    24.4
    2    14.4
    dtype: float64



few it is still there! instead the series.apply function has returned a new copy of our data. All we need to do is assign the value being returned to a new variable


```python
my_series_data_types = my_series.apply(lambda x: type(x))
print("\nmy_series_data_types")
print(my_series_data_types)
print("\nmy_series")
print(my_series)
```

    
    my_series_data_types
    0    <class 'float'>
    1    <class 'float'>
    2    <class 'float'>
    dtype: object
    
    my_series
    0    34.4
    1    24.4
    2    14.4
    dtype: float64
    

now we can easily access each set of data!

### dataframes are a type
just like we put our float into a list and our list into a series we now put our series into a datafram. Now we have more the 1 axis!


```python
my_data_frame = pd.DataFrame( {
                   'axisOne' : my_series, 
                   'axisTwo' : pd.Series([ "bread", 6.5, 8.7])
               })
my_data_frame
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>axisOne</th>
      <th>axisTwo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>34.4</td>
      <td>bread</td>
    </tr>
    <tr>
      <th>1</th>
      <td>24.4</td>
      <td>6.5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14.4</td>
      <td>8.7</td>
    </tr>
  </tbody>
</table>
</div>



oh no, I created our dataframe with some bad data, a string. How will we clean this dataframe considering the concepts so far?

### applying the concepts


```python
#first lets look at the types we get
def cleaning_function( parameter ):
    print(type(parameter))
    
_ = my_data_frame.apply(cleaning_function, axis=1) # because we are dealing with multiple axes 
                                                                               # of the dataframe we should specify which axis
                                                                               # we perform the operation on, in this case we 
                                                                               # we want to remove the rows
```

    <class 'pandas.core.series.Series'>
    <class 'pandas.core.series.Series'>
    <class 'pandas.core.series.Series'>
    

ok cool we get a type series for each row.


```python
#second what type do we get when we access the series
def access_the_series( parameter ):
    print(type(parameter))
    return parameter

def cleaning_function( parameter ):
    parameter.apply(access_the_series) # we have to go deeper. Remember this is a series
    return parameter 

_ = my_data_frame.apply(cleaning_function, axis=1)

```

    <class 'float'>
    <class 'str'>
    <class 'float'>
    <class 'str'>
    <class 'float'>
    <class 'float'>
    <class 'float'>
    <class 'float'>
    

ok cool we get a type of float for each item in the series.


```python
# Now we want to check if the float is string. If it is we just set it to 0 right?
def access_the_series( parameter ):
    if isinstance(parameter, str):
        return 0.0
    return parameter

def cleaning_function( parameter ):
    cleaned_parameter = parameter.apply(access_the_series) # remember a copy is made, no mutations of the series
    return cleaned_parameter 

cleaned_my_data_frame = my_data_frame.apply(cleaning_function, axis=1)

```


```python
print("cleaned data")
cleaned_my_data_frame
```

    cleaned data
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>axisOne</th>
      <th>axisTwo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>34.4</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>24.4</td>
      <td>6.5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14.4</td>
      <td>8.7</td>
    </tr>
  </tbody>
</table>
</div>




```python
print("orignal data")
my_data_frame
```

    orignal data
    




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>axisOne</th>
      <th>axisTwo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>34.4</td>
      <td>bread</td>
    </tr>
    <tr>
      <th>1</th>
      <td>24.4</td>
      <td>6.5</td>
    </tr>
    <tr>
      <th>2</th>
      <td>14.4</td>
      <td>8.7</td>
    </tr>
  </tbody>
</table>
</div>



### summary
I hope it is not too confusing and this gives you the fundemental understanding of how pandas works.

Of course you would typically use the many usefull functions pandas comes with and not write this stuff yourself!

If you want to do something, there is probably an easy way to do it already! Have a look at the links below:

https://pandas.pydata.org/pandas-docs/stable/user_guide/10min.html
https://pandas.pydata.org/pandas-docs/stable/user_guide/cookbook.html#cookbook




```python

```
