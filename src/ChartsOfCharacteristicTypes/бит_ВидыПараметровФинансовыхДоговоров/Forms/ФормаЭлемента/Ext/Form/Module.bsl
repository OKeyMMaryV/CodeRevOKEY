﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// Вызов механизма защиты
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Объект.Код = СтрЗаменить(Объект.Код," ","");
	СпецСимволы = " ,;:[]{}'""/\?!@#$%^&*+=<>~`|()1234567890№";
	Объект.Код = бит_ОбщегоНазначенияКлиентСервер.ПроверитьСпецСимволы(Объект.Код,СпецСимволы,"Имя");
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
	
		Объект.Наименование = Объект.Код;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Код) Тогда
	
		Объект.Код = СтрЗаменить(ТРег(Объект.Наименование)," ","");
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость/доступность элементов формы.
// 
&НаСервере
Процедура УстановитьВидимость()

	Элементы.Код.ТолькоПросмотр         = Объект.Предопределенный;
	Элементы.ТипЗначения.ТолькоПросмотр = Объект.Предопределенный;

КонецПроцедуры // УстановитьВидимость()

#КонецОбласти