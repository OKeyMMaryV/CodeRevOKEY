﻿
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм = Константы.ИспользоватьСервисФормированияМЧБсPDF417.Получить();
	ИспользоватьВебСервисТолькоВРежимеВебКлиента           = Константы.ИспользоватьСервисФормированияМЧБсPDF417ТолькоВРежимеВебКлиента.Получить();
	АдресТочкиПодключенияВебСервиса                        = Константы.АдресСервисаФормированияМЧБсPDF417.Получить();
	ИмяПользователяВебСервиса                              = Константы.ИмяПользователяСервисаФормированияМЧБсPDF417.Получить();
	ПарольПользователяВебСервиса                           = Константы.ПарольПользователяСервисаФормированияМЧБсPDF417.Получить();
	
	Если НЕ ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм Тогда
		Элементы.ИспользоватьВебСервисТолькоВРежимеВебКлиента.Доступность = Ложь;
		Элементы.ГруппаПараметрыДоступаКВебСервису.Доступность = Ложь;
	КонецЕсли;
	
	мЗадаватьВопросПриЗакрытии = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы = Истина Тогда
		Если Модифицированность И мЗадаватьВопросПриЗакрытии Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru='Настройки не сохранены.
				|Нажмите кнопку [Сохранить и закрыть]
				|или закройте окно вручную, до выхода из программы.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И мЗадаватьВопросПриЗакрытии Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Сохранить настройки?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если НЕ СохранитьНастройки() Тогда
			Возврат;
		КонецЕсли;
		мЗадаватьВопросПриЗакрытии = Ложь;
		Закрыть(Истина);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		мЗадаватьВопросПриЗакрытии = Ложь;
		Закрыть(Ложь);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Функция СохранитьНастройки()
	
	СохранитьНастройкиНаСервере();
	
	Возврат Истина;
	
КонецФункции 

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	Константы.ИспользоватьСервисФормированияМЧБсPDF417.Установить(ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм);
	Константы.ИспользоватьСервисФормированияМЧБсPDF417ТолькоВРежимеВебКлиента.Установить(ИспользоватьВебСервисТолькоВРежимеВебКлиента);
	Константы.АдресСервисаФормированияМЧБсPDF417.Установить(АдресТочкиПодключенияВебСервиса);
	Константы.ИмяПользователяСервисаФормированияМЧБсPDF417.Установить(ИмяПользователяВебСервиса);
	Константы.ПарольПользователяСервисаФормированияМЧБсPDF417.Установить(ПарольПользователяВебСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если НЕ СохранитьНастройки() Тогда
		Возврат;
	КонецЕсли;
	
	мЗадаватьВопросПриЗакрытии = Ложь;
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВебСервисДляФормированияМашиночитаемыхФормПриИзменении(Элемент)
	
	Элементы.АдресТочкиПодключенияВебСервиса.Доступность              = ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм;
	Элементы.ИспользоватьВебСервисТолькоВРежимеВебКлиента.Доступность = ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм;
	Элементы.ГруппаПараметрыДоступаКВебСервису.Доступность            = ИспользоватьВебСервисДляФормированияМашиночитаемыхФорм;
		
	Если ПустаяСтрока(АдресТочкиПодключенияВебСервиса) Тогда
		АдресТочкиПодключенияВебСервиса = "http://localhost/wsrep";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти