﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

//Получает параметры формы для отрытия записи регистра
//
Функция ПолучитьПараметрыОткрытияФормыЗаписиДоговора(Организация, Контрагент, ДоговорКонтрагента) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат(Неопределено);
	КонецЕсли;
	
	ПараметрыДоговора = РегистрыСведений.ДоговорыУчастниковКонтролируемыхСделок.СоздатьНаборЗаписей();
	ПараметрыДоговора.Отбор.Контрагент.Значение 				= Контрагент;
	ПараметрыДоговора.Отбор.Контрагент.Использование 			= Истина;
	ПараметрыДоговора.Отбор.ДоговорКонтрагента.Значение 		= ДоговорКонтрагента;
	ПараметрыДоговора.Отбор.ДоговорКонтрагента.Использование 	= Истина;
	ПараметрыДоговора.Отбор.Организация.Значение 				= Организация;
	ПараметрыДоговора.Отбор.Организация.Использование 			= Истина;
	ПараметрыДоговора.Прочитать();
	
	Если ПараметрыДоговора.Количество()>0 Тогда
		ПараметрыФормы = Новый Структура("Ключ", РегистрыСведений.ДоговорыУчастниковКонтролируемыхСделок.СоздатьКлючЗаписи(
			Новый Структура("Организация, Контрагент, ДоговорКонтрагента", Организация, Контрагент, ДоговорКонтрагента)));
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения",
			Новый Структура("Организация, Контрагент, ДоговорКонтрагента", Организация, Контрагент, ДоговорКонтрагента));
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ДоступностьКлючевыхЗаписей",Ложь);
	
	Возврат(ПараметрыФормы);
	
КонецФункции

#КонецЕсли