struct ArrayAndChar{T,N} <: AbstractArray{T,N}
    data::Array{T,N}
    Char::Char
end 
Base.size(A::ArrayAndChar) = size(A.data)
Base.getindex(A::ArrayAndChar{T,N}, inds::Vararg{Int,N}) where {T,N} = A.data[inds...]
Base.setindex!(A::ArrayAndChar{T,N}, val, inds::Vararg{Int,N}) where {T,N} = A.data[inds...] = val
Base.showarg(io::IO, A::ArrayAndChar, toplevel) = print(io, typeof(A), " with char '", A.char, "'")

function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{ArrayAndChar}}, ::Type{ElType}) where ElType
    A = find_aac(bc)
    ArrayAndChar(similar(Array{ElType}, axes(bc)), A.char)
end

find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)
find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
find_aac(x) = x
find_aac(::Tuple{}) = nothing
find_aac(a::ArrayAndChar, rest) = a
find_aac(::Any, rest) = find_aac(rest)

#ITERABLE INTERFACE 
struct MyRange 
    start::Int
    stop::Int 
end 

Base.iterate(r::MyRange, state=r.start) = state > r.stop ? nothing : (state, state+1)

for i in MyRange(1,5)
    println(i)
end  #( 1 2 3 4 5) 

#INDEXIBLE INTERFACE 
struct MyVector 
    data::Vector{Int}
end 

Base.getindex(v::MyVector, i::Int) = v.data[i]

v = MyVector([10, 20, 30])
println(v[2])
# 20 is output 
#SHOWABLE INTERFACE 
struct Point 
    x::Float64
    y::Float64
end 

Base.show(io::IO, p::Point) = print(io, "Point($(p.x), $(p.y))")

p = Point(3.0, 4.0)
println(p)
# Point(3.0, 4.0)
#EQUALITY INTERFACE
struct Person 
    name::String 
    age::Int 
end 

Base.:(==)(p1::Person, p2::Person) = p1.name == p2.name && p1.age == p2.age

p1 = Person("Alice", 30)
p2= Person("Junku", 23)
println(p1 == p2)
#False
julia> Base.iterate(S::Squares, state=1) = stathing : (state*state, state+1)

julia> for item in Squares(7)
           println(item)
       end
1
4
9
16
25
36
49

julia> 25 in Squares(10)
true

julia> 49 in Squares(20)
true

julia> 0 in Squares(10)
false

julia> sum(Squares(10))
385

julia> Base.eltype(::Type{Squares}) = Int

julia> Base.length(S::Squares) = S.count

julia> collect(Squares(4))
4-element Vector{Int64}:
  1
  4
  9
 16

julia> collect(Squares(20))
20-element Vector{Int64}:
   1
   4
   9
  16
  25
  36
  49
  64
   ⋮
 196
 225
 256
 289
 324
 361
 400

julia> collect(Iterators.reverse(Squares(4)))
4-element Vector{Int64}:
 16
  9
  4
  1

julia> s = SquaresVector(4)
4-element SquaresVector:
  1
  4
  9
 16

julia> s[s.>8]
2-element Vector{Int64}:
  9
 16

julia> s + s
4-element Vector{Int64}:
  2
  8
 18
 32
