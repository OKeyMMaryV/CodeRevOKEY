﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиУчетныхЗаписейДокументооборота КАК ПользователиУчетныхЗаписей
	| ПО ПользователиУчетныхЗаписей.УчетнаяЗапись = ЭтотСписок.ТранспортноеСообщение.УчетнаяЗапись
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	| ЭтоАвторизованныйПользователь(ПользователиУчетныхЗаписей.Пользователь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти
	
#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("РегистрСведений", "СодержимоеТранспортныхКонтейнеров", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
