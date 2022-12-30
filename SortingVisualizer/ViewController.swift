//
//  ViewController.swift
//  SortingVisualizer
//
//  Created by Andreea Bitlan on 25/12/22.
//

import Cocoa
import SwiftUI
import Charts

struct ContentView:View{
    var input: [Int]{
        var array = [Int]()
        for i in 1...60{
            array.append(i)
            }
        return array.shuffled()
    }
    @State var data = [Int]()
    @State var activeValue = 0
    @State var previousValue = 0
    @State var checkValue : Int?
    
    var body: some View{
        VStack{
            Chart{
                ForEach(Array(zip(data.indices,data)), id: \.0){ index, item in
                    BarMark(x: .value("POS", index),y: .value("Val", item))
                        .foregroundStyle(getColor(value: item).gradient)
                }
            }
            .frame(width: 560,height: 540)
            HStack{
                Button {
                    Task{
                        try await BubbleSort()
                        activeValue = 0
                        previousValue = 0
                        
                        
                        try await Sorted()
                    }
                } label: {
                Text("BubbleSort")
                }
                Button {
                    Task{
                        try await SelectionSort()
                        activeValue = 0
                        previousValue = 0
                        
                        
                        try await Sorted()
                    }
                } label: {
                Text("SelectionSort")
                }
                Button {
                    Task{
                        try await InsertSort()
                        activeValue = 0
                        previousValue = 0
                        
                        
                        try await Sorted()
                    }
                } label: {
                Text("InsertSort")
                }
                Button {
                    Task{
                        try await ShellSort()
                        activeValue = 0
                        previousValue = 0
                        
                        try await Sorted()
                    }
                } label: {
                Text("ShellSort")
                }
                Button {
                    Task{
                        try await RadixSort()
                        activeValue = 0
                        previousValue = 0
                        
                        
                        try await Sorted()
                    }
                } label: {
                Text("RadixSort")
                }
            }
            HStack{
                Button {
                    Task{
                        checkValue=0
                        data.shuffle( )
                    }
                }label:{
                        Text("Refresh")
                    }
            }
        }.frame(width: 760,height: 740)
        
        .onAppear{
            data = input
        }
    }
    
    
    func Sorted()async throws{
        for i in 0..<data.count{
            checkValue = data[i]
            try await Task.sleep(until: .now.advanced(by: .milliseconds(5)), clock: .continuous)
        }
        try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
    }
    
    @MainActor
    func BubbleSort() async throws{
        guard data.count>1 else{
            return
        }
        for i in 0..<data.count{
            for j in 0..<data.count - i - 1{
                if data[j]>data[j+1]{
                    activeValue=data[j+1]
                    previousValue=data[j]
                    
                    
                    data.swapAt(j+1, j)
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(20)), clock: .continuous)
                }
            }
        }
    }
    @MainActor
    func SelectionSort() async throws{
        guard data.count > 1 else{
            return
        }
        for i in 0..<data.count - 1{
            var jmin = data[i]
            previousValue = data[i]
            
            for j in i+1..<data.count{
                if (data[j]<data[jmin]){
                    activeValue = data[j]
                    jmin = j
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
                }
            }
            if (jmin != i){
                activeValue = data[i]
                previousValue = data[jmin]
                data.swapAt(i, jmin)
                try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
            }
        }
    }
    func InsertSort() async throws{
        guard data.count>1 else{
            return
        }
        for i in 0..<data.count{
            let key = data[i]
            var j = i-1
            
            while (j>=0 && data[j]>key){
                
                activeValue=data[j+1]
                previousValue=data[j]
                
                data[j+1]=data[j]
                j-=1
                try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
            }
            data[j+1]=key
        }
    }
    func RadixSort() async throws{
        guard data.count>1 else{
            return
        }
        let m = 60
        var exp = 1
        var out :[Int] = []
        
        while (60/exp>1){
            exp*=10
            var c = Array(repeating: 0,count: 10)
            for i in 0..<60{
                let x = (data[i]/exp)%10
                c[x]+=1
            }
            for i in 1..<10{
                c[i]+=c[i-1]
            }
            for i in 1..<60{
                out.append(data[i])
            }
            for i in (0...m-1).reversed(){
                activeValue=data[c[(out[i]/exp)%10]-1]
                data[c[(out[i]/exp)%10]-1]=out[i]
                c[(out[i]/exp)%10]-=1
                try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
            }
            
        
            
            try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
        }
        
    }
    func ShellSort() async throws{
        var interval = 60/2
        while (interval>0){
            for i in interval..<60{
                let temp = data[i]
                var j=i
                while (j>=interval && data[j-interval]>temp){
                    activeValue = data[j]
                    previousValue = data[j - interval]
                    
                    data[j] = data[j - interval]
                    j -= interval
                    
                    try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
                }
                data[j]=temp
            }
            interval/=2
            //try await Task.sleep(until: .now.advanced(by: .milliseconds(10)), clock: .continuous)
        }
        
    }
    func getColor(value:Int) -> Color{
        if let checkValue,value<=checkValue{
            return .green
        }
        if value == activeValue{
            return .red
        }else if value == previousValue{
            return .cyan
        }
        return .blue
    }
    
}

struct Contentview_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
    
}


