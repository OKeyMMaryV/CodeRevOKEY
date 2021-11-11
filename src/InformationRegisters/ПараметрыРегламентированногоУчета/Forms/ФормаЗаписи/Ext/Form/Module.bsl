﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//
Процедура ЗаполнитьЗначениямиПоУмолчаниюНаДату(Дата)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Период", Дата);
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ПараметрыРегламентированногоУчетаСрезПоследних.ИспользуетсяПостановлениеНДС1137
	               |ИЗ
	               |	РегистрСведений.ПараметрыРегламентированногоУчета.СрезПоследних(&Период, ) КАК ПараметрыРегламентированногоУчетаСрезПоследних";
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ЗаполнитьЗначениямиПоУмолчаниюНаДату(Запись.Период);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		ЗаполнитьЗначениямиПоУмолчаниюНаДату(Запись.Период);
	КонецЕсли;
	
КонецПроцедуры
