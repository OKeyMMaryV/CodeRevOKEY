﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
			
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
	КонецЦикла;

КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" полей воода - простых параметров на форме.
// 
&НаКлиенте
Процедура ПростойПараметрПриИзменении(Элемент)
	
	ИмяПараметра = Элемент.Имя;
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
															
КонецПроцедуры // ПростойПараметрПриИзменении()
														
// Процедура - обработчик события "ПриИзменении" 
// поля "КомпоновщикНастроекПользовательскиеНастройки".
// 
&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиПриИзменении(Элемент)
	
	Для каждого ИдЭлемента Из Элемент.ВыделенныеСтроки Цикл
		
		НастройкаКд  = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдЭлемента);
		Если ТипЗнч(НастройкаКд) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			
			ИмяПараметра = Строка(НастройкаКд.Параметр);
			
			Если фСписокПараметровНаФорме.НайтиПоЗначению(ИмяПараметра) <> Неопределено Тогда
				
				Отчет[ИмяПараметра] = НастройкаКд.Значение;
				
				Если ИмяПараметра = "Период" Тогда
			 		ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, Отчет.Период.ДатаОкончания);
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // КомпоновщикНастроекПользовательскиеНастройкиПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы
                           
// Процедура - обработчик команды "КомандаЗавершитьРедактирование".
// 
&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПользовательскиеНастройки" , Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	
	// Оповещение формы отчета
	Оповестить("ИзмененыНастройки_" + фПолноеИмяОтчета, СтруктураПараметров);
	
	Закрыть();
	
КонецПроцедуры // КомандаЗавершитьРедактирование()

#КонецОбласти
