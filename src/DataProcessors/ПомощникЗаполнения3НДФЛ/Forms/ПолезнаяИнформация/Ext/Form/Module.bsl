﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	Заголовок = Параметры.ЗаголовокФормы;
	КлючСохраненияПоложенияОкна = Параметры.КлючНазначенияФормы;
	
	Элементы.ДекорацияКакИзменитьДекларацию.Видимость = (Параметры.КлючНазначенияФормы = "КакИзменитьДекларацию");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "РегламентированнаяОтчетность" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
		ПараметрыФормы.Вставить("Организация", Организация);
		ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыФормы, , "1С-Отчетность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
