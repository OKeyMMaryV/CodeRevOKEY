﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-09-25 (#3868)
	УстановитьПривилегированныйРежим(Истина);
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-09-25 (#3868)
	
	СтандартнаяОбработка = Ложь;
		
	ДокументРезультат.Очистить();
	
	Настройки = СхемаКомпоновкиДанных.ВариантыНастроек[?(ВывестиВРазрезеАналитик,"РазвернутыйПоАналитикам","Свернутый")].Настройки;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
		   
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ФВБ", ФВБ, Истина); 	
				
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки());
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
		
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры
