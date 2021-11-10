﻿
#Область ОбработчикиСобытийФормы

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
															Отчет.Период.ДатаНачала, 
															"Период", 
															"ДатаНачала");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период.ДатаОкончания, 
															"Период", 
															"ДатаОкончания");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				 Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период.Вариант, 
															"Период", 
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
				
				Если ИмяПараметра = "Период" Тогда
			 		ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, Отчет.Период.ДатаОкончания);
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // КомпоновщикНастроекПользовательскиеНастройкиПриИзменении()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Отчеты.бит_ОтчетПоПланируемымРасходамДенежныхСредств;
	фПолноеИмяОтчета  = МетаданныеОбъекта.ПолноеИмя();
	
	ЗаполнитьДополнительныеСписки();
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		Отчет[ИмяПараметра] = Параметры[ИмяПараметра];
	КонецЦикла;
	Отчет.НастройкаПериода 		 = Параметры.НастройкаПериода;
			
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет, , Истина);
			
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

&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	фСписокПараметровНаФорме.Добавить("Период");
	
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

#КонецОбласти

