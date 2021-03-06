
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_ОбъектыМобильногоВизирования;
		
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьКэшЗначений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"                             , фКэшЗначений.СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"                     , Запись.ОбъектСистемы);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы"                  , фКэшЗначений.ДоступныеОбъектыСистемы);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСистемыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ОбъектСистемы) Тогда
		
		Запись.Синоним = ОбъектСистемыПриИзмененииНаСервере(Запись.ОбъектСистемы);
		
	КонецЕсли;	
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыборПоляЗавершение".
// 
// Параметры:
// ВыбранныеЭлемент - Строка
// Параметры - Структура
// 
&НаКлиенте
Процедура ВыборПоляЗавершение(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(Элементы.Синоним.ВыделенныйТекст) Тогда
			
			Элементы.Синоним.ВыделенныйТекст = Элементы.Синоним.ВыделенныйТекст + " " + СформироватьТекстШаблона(ВыбранныйЭлемент);
			
		Иначе
			
			Запись.Синоним = Запись.Синоним 
			                 + ?(ЗначениеЗаполнено(Запись.Синоним), " ", "")
							 + СформироватьТекстШаблона(ВыбранныйЭлемент);
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВставитьШаблон(Команда)
	
	Опов = Новый ОписаниеОповещения("ВыборПоляЗавершение", ЭтотОбъект);
	фКэшЗначений.СписокПолей.ПоказатьВыборЭлемента(Опов, "Выберите поле");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьТекстШаблона(ВыбранныйЭлемент)
	
	 ТекстШаблона = "{{"
						+ ?(ЗначениеЗаполнено(ВыбранныйЭлемент.Значение)
						    , ВыбранныйЭлемент.Представление + ":" + ВыбранныйЭлемент.Значение
							, ВыбранныйЭлемент.Представление)
					 + "}}";
					 
	 Возврат ТекстШаблона;				 
	
КонецФункции	

&НаСервереБезКонтекста
Функция ОбъектСистемыПриИзмененииНаСервере(ОбъектСистемы)
	
	Возврат ОбъектСистемы.Наименование;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Документ);
	Если бит_ОбщегоНазначения.ЭтоСемействоERP() Тогда
		СписокВидовОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Справочник);
	КонецЕсли; 
	
	фКэшЗначений.Вставить("СписокВидовОбъектов", СписокВидовОбъектов);
	
	ДоступныеОбъектыСистемы = бит_Визирование.ВизируемыеОбъектыСистемы();
	фКэшЗначений.Вставить("ДоступныеОбъектыСистемы", ДоступныеОбъектыСистемы);
	
	фКэшЗначений.Вставить("СписокПолей", РегистрыСведений.бит_ОбъектыМобильногоВизирования.СформироватьСписокПолей());
	
КонецПроцедуры	

#КонецОбласти