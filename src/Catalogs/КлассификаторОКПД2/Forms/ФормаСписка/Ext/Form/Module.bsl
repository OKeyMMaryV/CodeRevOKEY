﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Не ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.КлассификаторОКПД2) Тогда
		Элементы.ФормаПодборИзКлассификатора.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ТекущийКод", Элементы.Список.ТекущиеДанные.Код);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПодборИзКлассификатораЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.КлассификаторОКПД2.Форма.ФормаПодбораКлассификатора", ПараметрыФормы, , , , , ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодборИзКлассификатораЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйЭлемент = ДобавитьЭлементКлассификатора(РезультатВыбора.Код, РезультатВыбора.Наименование);
	
	ОповеститьОбИзменении(НовыйЭлемент);
	
	Элементы.Список.ТекущаяСтрока = НовыйЭлемент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьЭлементКлассификатора(Код, Наименование)
	
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Возврат Справочники.КлассификаторОКПД2.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Код", Код);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторОКПД2.Ссылка
	|ИЗ
	|	Справочник.КлассификаторОКПД2 КАК КлассификаторОКПД2
	|ГДЕ
	|	КлассификаторОКПД2.Код = &Код";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		НовыйЭлемент = Справочники.КлассификаторОКПД2.СоздатьЭлемент();
		НовыйЭлемент.Код = Код;
		НовыйЭлемент.Наименование = Наименование;
		НовыйЭлемент.НаименованиеПолное = Наименование;
		НовыйЭлемент.Записать();
		Возврат НовыйЭлемент.Ссылка;
	КонецЕсли;
	
КонецФункции

#КонецОбласти