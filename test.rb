# Hello World Program in Ruby
puts "Hello World!";
require 'fiber'

class Per
    
    def ite
        cnt = 0
        while cnt < @a
            Fiber.yield cnt
            cnt += 1
        end
    end
    
    def save_fiber
        return unless @fiber
        @saved = @fiber
        p 'fiber saved'
    end
    
    def st
        @a = 20
        @fiber = Fiber.new{ite}
        if @fiber.alive?
            p @fiber.resume
            save_fiber
        end
        puts "#{@fiber} #{@saved}"
        st2
        puts "#{@fiber} #{@saved}"
        @fiber = @saved
        @saved = nil
        @a = 10
        while @fiber.alive? do
            p @fiber.resume
        end
    end
    
    def st2
        p 'ST2'
        @fiber = Fiber.new{ite}
        while @fiber.alive? do
            p @fiber.resume
        end
    end
end

a = Per.new
a.st