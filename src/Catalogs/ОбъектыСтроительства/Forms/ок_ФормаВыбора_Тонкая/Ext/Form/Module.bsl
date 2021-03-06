#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если (РольДоступна("Guest")) и (Не РольДоступна("бит_ФинансистПолныеПрава")) Тогда
		мПараметрыСеанса	= Новый Структура;
		ОпределитьПараметрыСеанса(мПараметрыСеанса);
		Если мПараметрыСеанса.ТекущийИнициатор.КатегорияДоступаКОбъектам <> Справочники.ОК_СтатусОбъекта.ПустаяСсылка() Тогда 
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка.[Статус объекта (Объекты строительства)]", мПараметрыСеанса.ТекущийИнициатор.КатегорияДоступаКОбъектам, ВидСравненияКомпоновкиДанных.ВИерархии,, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтображениеСписка") Тогда 
		Элементы.Список.Отображение = Параметры.ОтображениеСписка;
	ИначеЕсли Параметры.Свойство("ОтображениеСпискаСтрокой") Тогда 
		Если Параметры.ОтображениеСпискаСтрокой = "Список" Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		ИначеЕсли Параметры.ОтображениеСпискаСтрокой = "ИерархическийСписок" Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;
		ИначеЕсли Параметры.ОтображениеСпискаСтрокой = "Дерево" Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.Дерево;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаСервере
Функция ОпределитьПараметрыСеанса(мПараметрыСеанса)

	мПараметрыСеанса.Вставить("ТекущийИнициатор", ПараметрыСеанса.бит_БК_ТекущийИнициатор);
	
	Возврат мПараметрыСеанса;
КонецФункции
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
