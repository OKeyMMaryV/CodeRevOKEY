﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Отчет);
	
	МетаданныеОбъекта = Метаданные.Отчеты.бит_му_СверкаВГО;
	
	// Вызов механизма защиты
	
	
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроекПоУмолчаниюТакси(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
														
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Видимость панели настроек
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
		
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	ОбработкаКомандыПанелиНастроекСервер();	
	
КонецПроцедуры // КомандаПанельНастроек()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
// Параметры: 
//  СкрытьПанельПриФормировании - Булево (По умолчанию = Ложь).
//
&НаСервере
Процедура ОбработкаКомандыПанелиНастроекСервер(СкрытьПанельПриФормировании = Ложь)
	
	// Видимость панели настроек
	бит_ОтчетыСервер.ОбработкаКомандыПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
													 , Элементы.ГруппаПанельНастроек
													 , фСкрытьПанельНастроек
													 , фТаксиОткрытьПанельНастроек
													 , СкрытьПанельПриФормировании);
	
КонецПроцедуры // ОбработкаКомандыПанелиНастроекСервер()

#КонецОбласти
