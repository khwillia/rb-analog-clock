#!/usr/bin/env ruby

class TwentyFourHourClock
end

class TwelveHourClock
end

HoursAndMinutes = Struct.new(:hours,:minutes)

def calculateHoursAngleFromMidnightClockwise(clockTypeSrc, clockTypeDest, hours)
  totalAngle = 0;

  if clockTypeSrc.is_a?(TwelveHourClock)
    if clockTypeDest.is_a?(TwelveHourClock)
      angleStep = 30  #For every hour you increment up or down by 30 degrees. Why? 3:00pm is 90deg away
                      # from midnight\noon, so 1pm is a third of that. By a third I picture it as creating
                      # three sections of this quarter circle, each having a 30 degree angle at the center.
    elsif clockTypeDest.is_a?(TwentyFourHourClock)
      angleStep = 15
    end

    totalAngle = hours*angleStep
  elsif clockTypeFrom.is_a?(TwentyFourHourClock)
    if clockTypeDest.is_a?(TwelveHourClock)
      angleStep = 30
      newHours = hours

      if (hours > 12)
        newHours = hours - 12
      end

      totalAngle = newHours*angleStep
    elsif clockTypeDest.is_a?(TwentyFourHourClock)
      angleStep = 15

      totalAngle = hours*angleStep
    end
  end
end

def calculateMinutesAngleFromMidnightClockwise(minutes)
   angleStep = 6; #90/15 = 6

   return minutes*angleStep;
end

if __FILE__ == $0
  clockType = TwelveHourClock.new

  paramsError = "Must be in the form:\n  ruby analog clock hh:mm [hh:mm]"
  if ARGV.length < 1 || ARGV.length > 2
    puts paramsError
    exit
  end

  areThereInvalidParams = false 

  timesArray = []

  ARGV.each do |a|
    puts "Argument: #{a}"

    if clockType.is_a?(TwelveHourClock) 
      if a =~ /([1][012]|[0][0-9]):([0123456][0-9])/
        puts "Matches Twelve hour clock"

        tokens = a.split(":")

        aTime = HoursAndMinutes.new(tokens[0].to_i,tokens[1].to_i)
        puts calculateHoursAngleFromMidnightClockwise(clockType, clockType, aTime.hours)
        puts calculateMinutesAngleFromMidnightClockwise(aTime.minutes)

        timesArray << aTime 
      end
    elsif clockType.is_a?(TwentyFourHourClock)
    else
      puts paramsError
      exit
    end
  end

  if timesArray.length == 1
    # If theres only one argument to the progam(a single timestamp)
    # then we find the angle between the hour and the minute hand.
  
    hoursAndMinutes = timesArray[0]
    angleFromMidnightForHourHand  = calculateHoursAngleFromMidnightClockwise(clockType, clockType, hoursAndMinutes.hours)
    angleFromMidnightForMinuteHand = calculateMinutesAngleFromMidnightClockwise(hoursAndMinutes.minutes)

    angleOfDifference = angleFromMidnightForHourHand - angleFromMidnightForMinuteHand

    otherAngleOfDifference = (360 - angleOfDifference).abs
    if otherAngleOfDifference < angleOfDifference
      angleOfDifference = otherAngleOfDifference
    end

    puts "The angle between the minute hand and the hour hand is:"
    puts angleOfDifference
  elsif timesArray.length == 2
    # If theres two arguments to the program we print the number of revolutions and
    # part revolutions for both the minute and the hour hand required to get from the
    # first of the two timestamps to the second.
  end
end
