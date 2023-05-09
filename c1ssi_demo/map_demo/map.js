var myChart = echarts.init(document.getElementById('main'));
	function updateMap(num){
				$(".control").show();
				$(".control:eq("+num+")").hide();
				myChart.clear();
				var opt = null;
				switch(num){
					case 0:{
						opt = {
						        title: {
						            text: '新冠疫情-国内累计数据',
						            link:'https://www.csgo.com.cn',
                                    subtext: '这里是rushb小队，集美们，打CS么？',
						            sublink:'https://www.csgo.com.cn'
						
						        },
						        tooltip: {
						            trigger: 'item', 
						            formatter: function (params, ticket, callback) {
						                if(params.data)
						                    return params.name+'<br/>'+params.data.value+' (人)';
						                else
						                    return params.name+'<br/>无疫情信息';
						            }
						        },
						        visualMap: {
						            type: 'piecewise',
						            pieces: [
						                {gt: 2000, color: 'darkred'},                       
						                {gt: 1300, lte: 2000, color: 'red', colorAlpha: 1}, 
						                {gt: 800, lte: 1300, color: 'red', colorAlpha: 0.8},
						                {gt: 500, lte: 800, color: 'red', colorAlpha: 0.6},
						                {gt: 200, lte: 500, color: 'red', colorAlpha: 0.4},
						                {gt: 50, lte: 200, color: 'red', colorAlpha: 0.3},
						                {lt: 50, color: 'red', colorAlpha: 0.2}       
						            ],
						        },
						        series: [
						            {
						                name: '国内各省确诊病例', 
						                zoom:1.2,
						                type: 'map', 
						                map: 'china', 
						                roam: true, 
						                label: {
						                    show: true,
						                    formatter: '{b}', 
						                    fontSize: 8
						                },
						                data: data.data,
						            }
						        ]
						    };
						
					}
					break;
					case 1:{
						opt = {
						        title: {
						            text: '新冠疫情-国内新增数据',
						            link:'https://www.csgo.com.cn',
						            subtext: '这里是rushb小队，集美们，打CS么？',
						            sublink:'https://www.csgo.com.cn'
					
						        },
						        tooltip: {
						            trigger: 'item', 
						            formatter:  function (params, ticket, callback) {
						                if(params.data)
						                    return params.name+'<br/>'+params.data.value+' (人)';
						                else
						                    return params.name+'<br/>无疫情信息';
						            }
						        },
						        visualMap: {
						            type: 'piecewise',
						            pieces: [
						                {gt: 50, color: 'darkred'},                        
						                {gt: 30, lte: 50, color: 'red', colorAlpha: 1},  
						                {gt: 20, lte: 30, color: 'red', colorAlpha: 0.8},
						                {gt: 10, lte: 20, color: 'red', colorAlpha: 0.6},
						                {gt: 5, lte: 10, color: 'red', colorAlpha: 0.4},
						                {gt: 1, lte: 5, color: 'red', colorAlpha: 0.3},
						                {lt: 1, color: 'red', colorAlpha: 0.0}        
						            ],
						        },
						        series: [{
						                name: '国内各省确诊病例', 
						                zoom:1.2,
						                type: 'map', 
						                map: 'china', 
						                roam: true, 
						                label: { 
						                    show: true,
						                    formatter: '{b}', 
						                    fontSize: 8
						                },
						                data: data.today,
						            }]
						    };	
					}
					break;
					case 2:{
						opt = {
						    title: {
						      text: '新冠疫情-全球累计数据',
						      link:'https://www.csgo.com.cn',
						            subtext: '这里是rushb小队，集美们，打CS么？',
						            sublink:'https://www.csgo.com.cn'
		
						    },
						    tooltip: {
						      trigger: 'item',
						      formatter:function (params, ticket, callback) {
						        if(params.data)
						          return params.name+'<br/>'+params.data.value+' (人)';
						        else
						          return params.name+'<br/> 未公布感染人数';
						      }
						    },
						    visualMap: {
						      min: 1, 
						      max: 500000, 
						      text: ['严重', '轻微'], 
						      realtime: true, 
						      calculable: true, 
						      inRange: {
						        color: ['rgba(222,0,0,0.2)','rgba(160,0,0,1)'] 
						      }
						    },
						    series: [{
						        name: '全球各国确诊病例', 
						        zoom:1.2,
						        type: 'map', 
						        map: 'world', 
						        roam: true, 
						        label: { 
						          show: true,
						          fontSize:8,
						          formatter:function (params, ticket, callback) {

						            if(params.data && params.data.value>50000) {
						              return params.name;
						            }else{
						              return '';
						            }
						          }
						        },
						        data: data.g_data,
						      }]
						  };
					}
					break;
					case 3:{
						opt = {
						    title: {
						      text: '新冠疫情-全球新增数据',
						      link:'https://www.csgo.com.cn',
						            subtext: '这里是rushb小队，集美们，打CS么？',
						            sublink:'https://www.csgo.com.cn'
			
						    },
						    tooltip: {
						      trigger: 'item', 
						      formatter:function (params, ticket, callback) {
						        if(params.data)
						          return params.name+'<br/>'+params.data.value+' (人)';
						        else
						          return params.name+'<br/> 未公布感染人数';
						      }
						    },
						    visualMap: {
						      min: 0, 
						      max: 20000, 
						      text: ['严重', '轻微'], 
						      realtime: true, 
						      calculable: true, 
						      inRange: {
						        color: ['rgba(160,0,0,0)','rgba(160,0,0,1)'] 
						      }
						    },
						    series: [
						      {
						        name: '全球各国新增病例', 
						        zoom:1.2,
						        type: 'map', 
						        map: 'world', 
						        roam: true, 
						        label: { 
						          show: true,
						          fontSize:8,
						          formatter:function (params, ticket, callback) {
						            if(params.data && params.data.value>1000 || params.name == '中国') {
						              return params.name;
						            }else{
						              return '';
						            }
						          }
						        },
						        data: data.g_today,
						      }
						    ]
						  };
					}
					break;
				}
				 myChart.setOption(opt);
			}
			updateMap(0);