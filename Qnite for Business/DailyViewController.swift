//
//  DailyViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import Charts

class DailyViewController: UIViewController {

    @IBOutlet weak var barChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get and prepare the data
        let sales = DataGenerator.data()
        
        // Initialize an array to store chart data entries (values; y axis)
        var salesEntries = [ChartDataEntry]()
        
        // Initialize an array to store months (labels; x axis)
        var salesMonths = [String]()
        
        var i: Double = 0
        for sale in sales {
            // Create single chart data entry and append it to the array
           // let saleEntry = BarChartDataEntry(value: sale.value, xIndex: i)
            let saleEntry = BarChartDataEntry(x: i, y: sale.value)
            salesEntries.append(saleEntry)
            
            // Append the month to the array
            salesMonths.append(sale.month)
            
            i += 1
        }
        
        // Create bar chart data set containing salesEntries
        //let chartDataSet = BarChartDataSet(yVals: salesEntries, label: "Profit")
        let chartDataSet = BarChartDataSet(values: salesEntries, label: "Profit")
        
        // Create bar chart data with data set and array with values for x axis
        //let chartData = BarChartData(xVals: salesMonths, dataSets: [chartDataSet])
        let chartData = BarChartData(dataSets: [chartDataSet])
            
        // Set bar chart data to previously created data
        barChart.data = chartData
        
        
        barChart.chartDescription?.text = nil
        barChart.xAxis.labelPosition = .bottom
        
        barChart.leftAxis.axisMinimum = 0.0
        barChart.leftAxis.axisMaximum = 1000.0
        
        //chartDataSet.colors = [.redColor(), .yellowColor(), .greenColor()]
        // Or this way. There are also available .liberty,
        // .pastel, .colorful and .vordiplom color sets.
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        barChart.legend.enabled = false
        
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        
        barChart.highlighter = nil
        
        barChart.rightAxis.enabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        
        barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
    
    }



}
