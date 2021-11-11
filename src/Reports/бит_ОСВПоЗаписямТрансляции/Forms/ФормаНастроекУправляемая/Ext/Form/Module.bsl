﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	
	ЗаполнитьКэшЗначений();
	
	ЗаполнитьДополнительныеСписки();
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		Отчет[ИмяПараметра] = Параметры[ИмяПараметра];
	КонецЦикла;
	
	Отчет.ПравилаЗаполненияПолей = Параметры.ПравилаЗаполненияПолей;
	
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
Процедура ПростойПараметрПриИзменении(Элемент)
	
	ИмяПараметра = Элемент.Имя;
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
															
КонецПроцедуры // ПростойПараметрПриИзменении()
														
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
                           
&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет, , Истина);
			
КонецПроцедуры // КомандаНастроитьПериод()

&НаКлиенте
Процедура КомандаНастроитьПериодПриемника(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет, "ПериодПриемника", Истина);
																
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НастройкаПериода", Отчет.НастройкаПериода);
	СтруктураПараметров.Вставить("НастройкаПериодаПриемника", Отчет.НастройкаПериодаПриемника);	
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
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	МетаОбъект = ОтчетОбъект.Метаданные();
	
	СписокВыбораОрганизации = Новый СписокЗначений;
	СписокВыбораОрганизации.ЗагрузитьЗначения(МетаОбъект.Реквизиты.Организация.Тип.Типы());
	
	фКэшЗначений.Вставить("СписокВыбораОрганизации", СписокВыбораОрганизации);
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии);
	
	фКэшЗначений.Вставить("СписокВидовОбъектов", СписокВидовОбъектов);
	
	СписокДоступныхОбъектов = бит_БухгалтерскиеОтчетыСервер.СформироватьСписокДоступныхРегистровБухгалтерииДляУправленческихОтчетов();
	
	ИмяХозрасчетный = "Хозрасчетный";	
	Если НЕ Метаданные.РегистрыБухгалтерии.Найти(ИмяХозрасчетный) = Неопределено Тогда
		
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(Метаданные.РегистрыБухгалтерии[ИмяХозрасчетный]);
		Если ЗначениеЗаполнено(ОбъектСистемы) Тогда
			СписокДоступныхОбъектов.Добавить(ОбъектСистемы);
		КонецЕсли;
		
	КонецЕсли;
	
	фКэшЗначений.Вставить("СписокДоступныхОбъектов", СписокДоступныхОбъектов);
	
КонецПроцедуры

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	ИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Ложь); 
	Отчеты[ИмяОтчета].ЗаполнитьДополнительныеСписки(фСписокПараметровНаФорме, фСписокДополнительныхСвойств);
		
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
													   , Элемент
													   , Отчет
													   , Элемент.Имя
													   , фКэшЗначений.СписокВыбораОрганизации
													   , СтандартнаяОбработка);
													   
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти
