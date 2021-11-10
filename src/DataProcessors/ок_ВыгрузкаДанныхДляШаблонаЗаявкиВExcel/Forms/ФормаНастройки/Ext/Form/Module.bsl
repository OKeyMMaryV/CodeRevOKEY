﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-04-28 (#3630)
	//мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", Неопределено);
	//Заменено на:
	//Программно добавляется реквизит ЭтоКорректировка
	ок_УправлениеФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	Параметры.Свойство("ЭтоКорректировка", ЭтотОбъект["ЭтоКорректировка"]);
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-12-01 (#3790)
	//Если ЭтотОбъект["ЭтоКорректировка"] Тогда 
	//	мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхККиЗБИзExcelФайла", Неопределено);
	//	Элементы.Страницы_ПоВидуДокумета.ТекущаяСтраница = Элементы.Страница_ККЗиБ;
	//Иначе 
	//	мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", Неопределено);
	//	Элементы.Страницы_ПоВидуДокумета.ТекущаяСтраница = Элементы.Страница_ФБВ;
	//КонецЕсли;
	Если ЭтотОбъект["ЭтоКорректировка"] = 1 Тогда 
		мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхККиЗБИзExcelФайла", Неопределено);
		Элементы.Страницы_ПоВидуДокумета.ТекущаяСтраница = Элементы.Страница_ККЗиБ;
	ИначеЕсли ЭтотОбъект["ЭтоКорректировка"] = 0 Тогда 
		мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", Неопределено);
		Элементы.Страницы_ПоВидуДокумета.ТекущаяСтраница = Элементы.Страница_ФБВ;
	ИначеЕсли ЭтотОбъект["ЭтоКорректировка"] = 2 Тогда 
		мКэшТекущихНастроек = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаЗагрузкиДанныхПТиУИзExcelФайла", Неопределено);
		Элементы.Страницы_ПоВидуДокумета.ТекущаяСтраница = Элементы.Страница_ПТиУ;
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-12-01 (#3790)
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-04-28 (#3630)
	
	Если мКэшТекущихНастроек <> Неопределено Тогда 
		
		//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Начало 20181106 (#3086)
		ДанныеРеквизитов = ПолучитьРеквизиты();
		//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Конец 20181106 (#3086)
			
		Для каждого ЭлементНастройки Из мКэшТекущихНастроек Цикл
			пИмяРеквизита = "н_" + ЭлементНастройки.Представление;
			
			//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Начало 20181106 (#3086)
			//сделал без использования Попытка
			//Попытка
			//	ЭтаФорма[пИмяРеквизита]	= ЭлементНастройки.Значение;
			//Исключение
			//КонецПопытки;
			ЕстьРеквизит = Ложь;
			Для каждого Реквизит из ДанныеРеквизитов Цикл
				Если Не ПустаяСтрока(Реквизит.Путь) Тогда
					Продолжить;
				ИначеЕсли Реквизит.Имя = пИмяРеквизита Тогда
					ЕстьРеквизит = Истина;
					Прервать;
				КонецЕсли;	
			КонецЦикла;
			Если Не ЕстьРеквизит Тогда
				Продолжить;
			КонецЕсли;	
			ЭтотОбъект[пИмяРеквизита] = ЭлементНастройки.Значение
			//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Конец 20181106 (#3086)
			
		КонецЦикла; 
	КонецЕсли;	
	
	//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Начало 20181106 (#3086)
	//скрыты с формы поля: ИмяЯчейки_ЦФО, ИмяЯчейки_ВалютаДокумента
	//переименованы реквизиты: н_ИмяЯчейки_ЦФО, н_ИмяЯчейки_ВалютаДокумента, добавлен префикс Удалить
	//добавлены реквизиты: н_НомерКолонки_ЦФО, н_НомерКолонки_Валюта, и выведены на форму
	//ОКЕЙ Вдовиченко Г.В. (СофтЛаб) Конец 20181106 (#3086)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНастройкиНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	пРеквизитыФормы = ПолучитьРеквизиты();
	
	СписокНастроек = Новый СписокЗначений;
	Для Каждого пРеквизит Из пРеквизитыФормы Цикл 
		Если Лев(пРеквизит.Имя,2) <> "н_" Тогда 
			Продолжить;
		КонецЕсли;
		СписокНастроек.Добавить(ЭтаФорма[пРеквизит.Имя],Сред(пРеквизит.Имя,3));
	КонецЦикла;
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-05-03 (#3630)
	//СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", СписокНастроек, Истина);
	//Заменено на:
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-12-01 (#3790)
	//Если ЭтотОбъект["ЭтоКорректировка"] Тогда 
	//	СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхККиЗБИзExcelФайла", СписокНастроек, Истина);
	//Иначе 
	//	СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", СписокНастроек, Истина);
	//КонецЕсли;
	Если ЭтотОбъект["ЭтоКорректировка"] = 1 Тогда 
		СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхККиЗБИзExcelФайла", СписокНастроек, Истина);
	ИначеЕсли ЭтотОбъект["ЭтоКорректировка"] = 0 Тогда  
		СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхЗаявкиИзExcelФайла", СписокНастроек, Истина);
	ИначеЕсли ЭтотОбъект["ЭтоКорректировка"] = 2 Тогда  
		СБ_КазначействоСервер.УстановитьЗначениеКонстанты("НастройкаЗагрузкиДанныхПТиУИзExcelФайла", СписокНастроек, Истина);
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-12-01 (#3790)
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-05-03 (#3630)
	
КонецПроцедуры

#КонецОбласти
