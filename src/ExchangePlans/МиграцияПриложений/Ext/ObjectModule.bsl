﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	Если ЭтоНовый() Тогда
		УстановитьПризнакИспользованияМиграции(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Разделитель", ОбластьДанныхОсновныеДанные);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Проверка
	|ИЗ
	|	ПланОбмена.МиграцияПриложений КАК МиграцияПриложений
	|ГДЕ
	|	НЕ МиграцияПриложений.ЭтотУзел
	|	И МиграцияПриложений.ОбластьДанныхОсновныеДанные = &Разделитель
	|	И МиграцияПриложений.Ссылка <> &Ссылка";
	Использование = Не Запрос.Выполнить().Пустой();
		
	УстановитьПризнакИспользованияМиграции(Использование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПризнакИспользованияМиграции(Использование)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ИспользуетсяМиграцияПриложений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		МенеджерЗначения = Константы.ИспользуетсяМиграцияПриложений.СоздатьМенеджерЗначения();
		МенеджерЗначения.ОбластьДанныхВспомогательныеДанные = ОбластьДанныхОсновныеДанные;
		МенеджерЗначения.Прочитать();
		Если Не МенеджерЗначения.Значение = Использование Тогда
			МенеджерЗначения.Значение = Использование;
			МенеджерЗначения.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли