﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	
	ЗаполнитьДополнительныеСписки();
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		Отчет[ИмяПараметра] = Параметры[ИмяПараметра];
	КонецЦикла;
	
	Отчет.НастройкаПериода 	= Параметры.НастройкаПериода;
		
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

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.СтандартныйПериод.ДатаНачала, 
															"СтандартныйПериод", 
															"ДатаНачала");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.СтандартныйПериод.ДатаНачала, 
																				Отчет.СтандартныйПериод.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.СтандартныйПериод.ДатаОкончания, 
															"СтандартныйПериод", 
															"ДатаОкончания");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.СтандартныйПериод.ДатаНачала, 
																				 Отчет.СтандартныйПериод.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.СтандартныйПериод.Вариант, 
															"СтандартныйПериод", 
															"Вариант");
		
КонецПроцедуры // ПериодВариантПриИзменении()
																										
&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиПриИзменении(Элемент)
	
	Для каждого ИдЭлемента Из Элемент.ВыделенныеСтроки Цикл
		
		НастройкаКд  = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдЭлемента);
		Если ТипЗнч(НастройкаКд) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			
			ИмяПараметра = Строка(НастройкаКд.Параметр);
			
			Если фСписокПараметровНаФорме.НайтиПоЗначению(ИмяПараметра) <> Неопределено Тогда
				
				Отчет[ИмяПараметра] = НастройкаКд.Значение;
				
				Если ИмяПараметра = "СтандартныйПериод" Тогда
			 		ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.СтандартныйПериод.ДатаНачала, Отчет.СтандартныйПериод.ДатаОкончания);
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // КомпоновщикНастроекПользовательскиеНастройкиПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы
                           
&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет, "СтандартныйПериод", Истина);
				
КонецПроцедуры // КомандаНастроитьПериод()

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НастройкаПериода", Отчет.НастройкаПериода);
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		СтруктураПараметров.Вставить(ИмяПараметра , Отчет[ИмяПараметра]);
	КонецЦикла;
	СтруктураПараметров.Вставить("ПользовательскиеНастройки" , Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	
	// Оповещение формы отчета
	Оповестить("ИзмененыНастройки_" + фПолноеИмяОтчета, СтруктураПараметров);
	
	Закрыть();
	
КонецПроцедуры // КомандаЗавершитьРедактирование()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	ИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Ложь); 
	Отчеты[ИмяОтчета].ЗаполнитьДополнительныеСписки(фСписокПараметровНаФорме);
		
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

#КонецОбласти

