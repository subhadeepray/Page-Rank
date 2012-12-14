class PageRank
    attr_accessor :pr , :n , :outlinks, :counter , :m , :s , :round, :iterations
    def initialize(file,iterations)
    	@filename = file
        @pr = Hash.new(0)
        @outlinks = Hash.new(0)
        @m = Hash.new(0)
        @s = Array.new(0)
        @n = 0
        @counter = 0
        @round = 1
        @iterations = iterations
    end
    
    def countlines()
    	puts "The links file to be processed is #{@filename} "
    	File.foreach(@filename) { |line| @n += 1 }
    	puts "The number of pages is #{@n}"
    end

    def setdefault()
    	File.foreach(@filename) do |line| 
    		arr = line.strip.split(/ /)
    		@pr[arr[0]] = (1/@n.to_f)
    	end
    end
    
    def outlinkz()
        File.foreach(@filename) do |line|
            arr = line.strip.split(/ /)
            @outlinks[arr[0]] = 0.0
        end
        File.foreach(@filename) do |line|
            ar = []
            arr = line.strip.split(/ /)
            arr[1..arr.length].each do |elem|
                ar << elem
            end
            @m[arr[0]] = ar
        end
        @m.each do |key,val|
                val.each do |x|
                    @outlinks[x] += 1.0
                end
        end
        @outlinks.each do |x,y|
            if y == 0
                @s << x
            end
        end
        #puts @outlinks
    end

    def pgrank()
        sinkPr = 0.00
        newPR = Hash.new(0)
        d = 0.85
        i = 0
        while(i < @iterations)
            sinkPr = 0.00
            @s.each do |p|
                    sinkPr += @pr[p].to_f
            end
            File.foreach(@filename) do |line|
                arr = line.strip.split(/ /)
                newPR[arr[0]] = (0.15/@n.to_f)
                newPR[arr[0]] += (0.85 *(sinkPr.to_f/@n.to_f))
                @m[arr[0]].each do |q|
                   newPR[arr[0]] += (d * (@pr[q].to_f/ @outlinks[q].to_f))
                end
            end
            @pr = newPR.dup
            i += 1
        end
        return @pr
    end

   
end

p_rank = PageRank.new('small.txt',1)
p_rank.countlines()
p_rank.setdefault()
p_rank.outlinkz()
hashed = p_rank.pgrank()
hashed.each do |k ,v|
    puts "#{k}  #{v}"
end
puts "---------------"
p_rank = PageRank.new('small.txt',10)
p_rank.countlines()
p_rank.setdefault()
p_rank.outlinkz()
hashed = p_rank.pgrank()
hashed.each do |k ,v|
    puts "#{k}  #{v}"
end
puts "---------------"
p_rank = PageRank.new('small.txt',100)
p_rank.countlines()
p_rank.setdefault()
p_rank.outlinkz()
hashed = p_rank.pgrank()
hashed.each do |k ,v|
    puts "#{k}  #{v}"
end
