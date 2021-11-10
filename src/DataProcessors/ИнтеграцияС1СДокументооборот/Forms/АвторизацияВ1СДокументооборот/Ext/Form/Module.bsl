﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = Константы.АдресВебСервиса1СДокументооборот.Получить();
	ЭтоПользовательЗаданияОбмена = ИнтеграцияС1СДокументооборотВызовСервера.ЭтоПользовательЗаданияОбмена();
	Параметры.Свойство("ВызовДляПользователяЗаданияОбмена", ВызовДляПользователяЗаданияОбмена);
	
	Если ВызовДляПользователяЗаданияОбмена
		Или ЭтоПользовательЗаданияОбмена Тогда
		ИмяПользователя = Константы.ИнтеграцияС1СДокументооборотИмяПользователяДляОбмена.Получить();
		Пароль = Константы.ИнтеграцияС1СДокументооборотПарольДляОбмена.Получить();
	КонецЕсли;
	
	#Если Не ВебКлиент Тогда
	// Добавим в список выбора имя пользователя ИС.
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	Элементы.ИмяПользователя.СписокВыбора.Добавить(ПользовательИБ.Имя);
	Элементы.ИмяПользователя.КнопкаВыпадающегоСписка = Истина;
	#КонецЕсли

	// Определим, доступна ли аутентификация ОС.
	ПроверитьИспользованиеАутентификацииОС();
	
	// Если вызов - автоматический, при проверке подключения, и аутентификация ОС оказалась успешной,
	// то форму открывать не нужно.
	Если Параметры.АвтоматическийВызовПриПроверкеПодключения
		И ИспользуетсяАутентификацияОС Тогда
		
		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПарольСохранен = Ложь;
	СохраненноеИспользуетсяАутентификацияОС = Ложь;
	
	Если Не ВызовДляПользователяЗаданияОбмена
		Или ЭтоПользовательЗаданияОбмена Тогда
		ИнтеграцияС1СДокументооборотКлиент.ПрочитатьНастройкиАвторизации(
			ИмяПользователя, ПарольСохранен, Пароль, СохраненноеИспользуетсяАутентификацияОС);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(ИмяПользователя)
		И Не ИспользуетсяАутентификацияОС Тогда
		ТекущийЭлемент = Элементы.ИмяПользователя;
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнено имя пользователя 1С:Документооборота.'"));
		Возврат;
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = "";
	Если ИнтеграцияС1СДокументооборотВызовСервера.ПроверитьПодключение(,
			ИмяПользователя,
			Пароль,
			ТекстСообщенияОбОшибке,
			Не ЗначениеЗаполнено(ИмяПользователя)) Тогда
			
		Если ВызовДляПользователяЗаданияОбмена
			Или	ЭтоПользовательЗаданияОбмена Тогда
			
			ИнтеграцияС1СДокументооборотВызовСервера.СохранитьНастройкиАвторизацииДляОбмена(ИмяПользователя, Пароль);
			
		КонецЕсли;
		
		Если Не ВызовДляПользователяЗаданияОбмена
			Или ЭтоПользовательЗаданияОбмена Тогда
			
			ИнтеграцияС1СДокументооборотКлиент.СохранитьНастройкиАвторизации(ИмяПользователя,
				Пароль,
				Не ЗначениеЗаполнено(ИмяПользователя));
			ИнтеграцияС1СДокументооборотВызовСервера.УстановитьВерсиюСервисаВПараметрыСеанса();
			Оповестить("ИнтеграцияС1СДокументооборотом_УспешноеПодключение", , ВладелецФормы);
			
		КонецЕсли;
		
		Закрыть(Истина);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект, ТекстСообщенияОбОшибке);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ОК", "ОК");
		Кнопки.Добавить("Подробнее", "Подробнее...");
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Не удалось подключиться к 1С:Документообороту с указанным
			|именем пользователя и паролем. Если вы уверены в их 
			|правильности, обратитесь к администратору.'"), Кнопки);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Результат, ТекстСообщенияОбОшибке) Экспорт

	Если Результат = "Подробнее" Тогда
		ПоказатьПредупреждение(, ТекстСообщенияОбОшибке);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, можно ли использовать аутентификацию ОС при подключении к ДО. Настраивает
// форму в зависимости от результата.
//
&НаСервере
Процедура ПроверитьИспользованиеАутентификацииОС()
	
	Если ИнтеграцияС1СДокументооборот.ПоддерживаетсяАутентификацияОС() Тогда
		ТекстСообщенияОбОшибке = "";
		Если ИнтеграцияС1СДокументооборотВызовСервера.ПроверитьПодключение(,
			"", // без имени пользователя
			"", // и пароля
			ТекстСообщенияОбОшибке,
			Истина) Тогда
			ИспользуетсяАутентификацияОС = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ДекорацияИспользуетсяАутентификацияОС.Видимость = ИспользуетсяАутентификацияОС;
	Элементы.ИмяПользователя.АвтоОтметкаНезаполненного = Не ИспользуетсяАутентификацияОС;
	КлючСохраненияПоложенияОкна = Строка(ИспользуетсяАутентификацияОС);
	
КонецПроцедуры

#КонецОбласти