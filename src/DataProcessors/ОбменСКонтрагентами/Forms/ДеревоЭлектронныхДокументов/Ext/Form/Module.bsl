﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("ИсходныйДокумент", ИсходныйДокумент);
	
	Параметры.Свойство("ОбъектОтбора", ОбъектСсылка);
	
	Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ОбновитьДеревоЭД();
	КонецЕсли;
	
	Элементы.ЖурналСобытий.Доступность = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура")
			И Параметр.Свойство("ДокументыУчета")
			И ТипЗнч(Параметр.ДокументыУчета) = Тип("Массив")
			И Параметр.ДокументыУчета.Количество() > 0
			И Параметр.ДокументыУчета.Найти(ОбъектСсылка) = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		ВывестиДеревоЭД();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьСтроки();
	
	Если ЗначениеЗаполнено(ИсходныйДокумент) Тогда
		УстановитьТекущуюСтроку();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодчиненныеЭД

&НаКлиенте
Процедура ДеревоПодчиненныеЭДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ДеревоПодчиненныеЭДОжидаемоеДействие" И Элемент.ТекущиеДанные.СтрокаДоступна Тогда
			СтандартнаяОбработка = Ложь;
			ВыполняемоеДействие = Элемент.ТекущиеДанные.ОжидаемоеДействие;
			Если ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Сформировать") Тогда
				
				Если Элемент.ТекущиеДанные.ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.ИзвещениеОПолучении")
					И Элемент.ТекущиеДанные.ПолучитьРодителя() <> Неопределено
					И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ПолучитьРодителя().Ссылка) Тогда
					
					МассивЭДДляИзвещений = Новый Массив;
					МассивЭДДляИзвещений.Добавить(Элемент.ТекущиеДанные.ПолучитьРодителя().Ссылка);
					ОбменСКонтрагентамиСлужебныйКлиент.СформироватьПодписатьСлужебныйЭД(МассивЭДДляИзвещений,
						Элемент.ТекущиеДанные.ВидЭД)
					
				ИначеЕсли (Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.ПервичныйЭД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.ЭСФ")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.СЧФДОПУПД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.СЧФУПД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.ДОПУПД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.КСЧФДИСУКД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.КСЧФУКД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.ДИСУКД")
					ИЛИ Элемент.ТекущиеДанные.ТипЭД = ПредопределенноеЗначение("Перечисление.ТипыЭлементовВерсииЭД.ДОП"))
					И НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка)
					И (Элемент.ТекущиеДанные.НаправлениеЭД = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий")
					ИЛИ Элемент.ТекущиеДанные.НаправлениеЭД = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Интеркампани")) Тогда
					
					Если Элемент.ТекущиеДанные.ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.КаталогТоваров") Тогда
						
						ДопПараметры = Новый Структура("СоглашениеОбИспользованииЭД", ОбъектСсылка);
						ОписаниеОповещения = Новый ОписаниеОповещения("СформироватьПодписатьОтправитьКаталогЗавершить",
							ОбменСКонтрагентамиСлужебныйКлиент, ДопПараметры);
						ОбменСКонтрагентамиКлиентПереопределяемый.ОткрытьФормуПодбораТоваров(
							ЭтотОбъект.УникальныйИдентификатор, ОписаниеОповещения);
						
					Иначе
						ОбменСКонтрагентамиКлиент.СформироватьНовыйЭД(ОбъектСсылка, Ложь);
					КонецЕсли;
				КонецЕсли;
				
			ИначеЕсли ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Утвердить")
				ИЛИ ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.УтвердитьОтправить") Тогда
				
				Если ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоОбработкиЭД(Истина) Тогда
					ОбменСКонтрагентамиСлужебныйКлиент.УтвердитьЭД(ОбъектСсылка, Элемент.ТекущиеДанные.Ссылка, Истина);
				КонецЕсли;
				
			ИначеЕсли ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Подписать")
				ИЛИ ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.ПодписатьОтправить") Тогда
				
				ОбменСКонтрагентамиКлиент.СформироватьПодписатьОтправитьЭД(Неопределено, Элемент.ТекущиеДанные.Ссылка);
				
			ИначеЕсли ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Отправить") Тогда
				
				ОтправитьЭД(Элемент.ТекущиеДанные.Ссылка);
			ИначеЕсли ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Принять") Тогда
				ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьПредложениеОбАннулировании(Элемент.ТекущиеДанные.ПолучитьРодителя().Ссылка);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока)
				И ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() > 1 Тогда
				Элементы.ДеревоПодчиненныеЭД.Развернуть(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока, Истина);
			КонецЕсли;
			
		Иначе
			ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элемент.ТекущиеДанные.Ссылка,, ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодчиненныеЭДПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	Если Элемент.ТекущийЭлемент <> Неопределено Тогда
		
		Если Элемент.ТекущийЭлемент.Имя = "ДеревоПодчиненныеЭДПредставление" Тогда
			
			Если Элемент.ТекущиеДанные <> Неопределено
				И ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ЭДПрисоединенныеФайлы")
				И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
				
				ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элемент.ТекущиеДанные.Ссылка,, ЭтотОбъект);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНаСервере(Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.Ссылка);
	РазвернутьСтроки();
	УстановитьТекущуюСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналСобытий(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные <> Неопределено Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("ПрисоединенныйФайл", Элементы.ДеревоПодчиненныеЭД.ТекущиеДанные.Ссылка);
		
		ПараметрыФормы.Вставить("Отбор", Отбор);
		ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ОткрытьФорму("РегистрСведений.ЖурналСобытийЭД.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокИдентификаторовСтрокДерева(Форма)
	
	Форма.СписокИдентификаторов.Очистить();
	Для Каждого ЭлементДерева Из Форма.ДеревоПодчиненныеЭД.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.АктуальныйЭД И НЕ ЭлементДерева.СтатусЭД = ПредопределенноеЗначение("Перечисление.СтатусыЭД.Отклонен") Тогда
			Форма.СписокИдентификаторов.Добавить(ЭлементДерева.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСтроки()
	
	Если СписокИдентификаторов.Количество()=0 Тогда
		ЗаполнитьСписокИдентификаторовСтрокДерева(ЭтотОбъект);
	КонецЕсли;
	
	Для Каждого Строка Из СписокИдентификаторов Цикл
		Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока = Строка.Значение;
		Элементы.ДеревоПодчиненныеЭД.Развернуть(Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере(ТекущаяСсылка)
	
	ОбновитьДеревоЭД();
	ОбновитьИндексТекущейСтроки(ТекущаяСсылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоЭД()

	УстановитьПривилегированныйРежим(Истина);
	ПараметрыОпределенияНастройки = Новый Структура("ВыводитьСообщения", Ложь);
	НастройкиОбмена = ОбменСКонтрагентамиСлужебный.ОпределитьНастройкиОбменаЭДПоИсточнику(ОбъектСсылка, ПараметрыОпределенияНастройки);
	СформироватьДеревьяЭД();
	
	Заголовок = НСтр("ru = 'Электронные документы:'") + " " + ОбъектСсылка;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяЭД()

	ДеревоПодчиненныеЭД.ПолучитьЭлементы().Очистить();
	
	ЭтоПроизвольныйЭД = Ложь; 
	
	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий")
		ИЛИ ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящий") Тогда
		
		
		ЭтоПроизвольныйЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка,"ВидЭД") = Перечисления.ВидыЭД.ПроизвольныйЭД;
		
		Если ЭтоПроизвольныйЭД Тогда
			СоответствиеВладельцевИЭД = Новый Соответствие;
			СоответствиеВладельцевИЭД.Вставить(ОбъектСсылка,ОбъектСсылка);
		Иначе
			МассивСсылокНаЭД = Новый Массив;
			МассивСсылокНаЭД.Добавить(ОбъектСсылка);
			СоответствиеВладельцевИЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.ВладельцыИЭлектронныеДокументы(,МассивСсылокНаЭД);
			Если НЕ ЗначениеЗаполнено(СоответствиеВладельцевИЭД) Тогда
				СоответствиеВладельцевИЭД.Вставить(ОбъектСсылка,ОбъектСсылка);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(ОбъектСсылка);
		
		СоответствиеВладельцевИЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.ВладельцыИЭлектронныеДокументы(МассивСсылок);
		
		// В случае, если у владельца нет актуального электронного документа, соответствие будет пустое.
		// Добавим в него сам документ, чтобы получить все остальные электронные по нему.
		Если Не ЗначениеЗаполнено(СоответствиеВладельцевИЭД) Тогда
			СоответствиеВладельцевИЭД = Новый Соответствие;
			СоответствиеВладельцевИЭД.Вставить(ОбъектСсылка);
		КонецЕсли;
	КонецЕсли;
	
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоПодчиненныеЭД");
	
	ОбменСКонтрагентамиСлужебный.СформироватьДеревьяЭД(ДеревоОбъект,СоответствиеВладельцевИЭД,НастройкиОбмена, НЕ ЭтоПроизвольныйЭД);
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоПодчиненныеЭД");
	
	ЗаполнитьСписокИдентификаторовСтрокДерева(ЭтотОбъект);
	ЗаполнитьИндексИД(ДеревоПодчиненныеЭД, ИсходныйДокумент);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИндексИД(ДеревоЭД, Ссылка)
	
	Для Каждого ЭлементДерева Из ДеревоЭД.ПолучитьЭлементы() Цикл
		
		Если ЭлементДерева.Ссылка = Ссылка Тогда
			ИндексИД = ЭлементДерева.ПолучитьИдентификатор();
		КонецЕсли;
		
		Если ЭлементДерева.ПолучитьЭлементы().Количество() > 0 Тогда
			 ЗаполнитьИндексИД(ЭлементДерева, Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтроку()
	
	Элементы.ДеревоПодчиненныеЭД.ТекущаяСтрока = ИндексИД;
	
КонецПроцедуры


// Инициирует вывод в дерево и отображает его по окончанию формирования.
&НаКлиенте
Процедура ВывестиДеревоЭД()

	ОбновитьДеревоЭД();
	РазвернутьСтроки();

КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексТекущейСтроки(ТекущаяСсылка)
	
	ЗаполнитьИндексИД(ДеревоПодчиненныеЭД, ТекущаяСсылка);
	
КонецПроцедуры

// Если для переданного ЭД есть подготовленный к отправке ПЭД, то получает его и отправляет.
// Иначе выполняется попытка сформировать новый ПЭД.
//
// Параметры:
//   ЭД - СправочникСсылка.ЭДПрисоединенныеФайлы.
//
&НаКлиенте
Процедура ОтправитьЭД(ЭД)
	
	МассивПакетовЭД = ПолучитьПакетЭДКОтправке(ЭД);
	Если МассивПакетовЭД.Количество() > 0 Тогда
		ОбменСКонтрагентамиСлужебныйКлиент.ОтправитьМассивПакетовЭД(МассивПакетовЭД);
	Иначе
		МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(ЭД);
		ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(Неопределено, "Отправить", , МассивСсылок);
	КонецЕсли;
	
КонецПроцедуры

// Выполняется поиск ПЭД, подготовленного к отправке.
//
// Параметры:
//   СсылкаЭД - СправочникСсылка.ЭДПрисоединенныеФайлы - ЭД для которого надо получить ПЭД.
//
// Возвращаемое значение:
//   Массив - элемент массива - ДокументСсылка.ПакетЭД.
//
&НаСервереБезКонтекста
Функция ПолучитьПакетЭДКОтправке(СсылкаЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПакетЭДЭлектронныеДокументы.Ссылка
	|ИЗ
	|	Документ.ПакетЭД.ЭлектронныеДокументы КАК ПакетЭДЭлектронныеДокументы
	|ГДЕ
	|	ПакетЭДЭлектронныеДокументы.ОбъектВладелец = &ОбъектВладелец
	|	И ПакетЭДЭлектронныеДокументы.Ссылка.СтатусПакета = ЗНАЧЕНИЕ(Перечисление.СтатусыПакетовЭД.ПодготовленКОтправке)
	|	И НЕ ПакетЭДЭлектронныеДокументы.Ссылка.ПометкаУдаления
	|	И ПакетЭДЭлектронныеДокументы.ЭлектронныйДокумент = &ЭлектронныйДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПакетЭДЭлектронныеДокументы.Ссылка.МоментВремени УБЫВ";
	Запрос.УстановитьПараметр("ОбъектВладелец", СсылкаЭД.ВладелецФайла);
	Запрос.УстановитьПараметр("ЭлектронныйДокумент", СсылкаЭД);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Количество() > 0 Тогда
		МассивПакетовЭД = Результат.ВыгрузитьКолонку("Ссылка");
	Иначе
		МассивПакетовЭД = Новый Массив;
	КонецЕсли;
	
	Возврат МассивПакетовЭД;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭД.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтрокаДоступна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДСтатусЭД.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ТипЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыЭлементовВерсииЭД.ЭСФ);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтатусЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Получен);
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.ПереданОператору);
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Отправлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ТипЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ТипыЭлементовВерсииЭД.ЭСФ);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтатусЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Доставлен);
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Утвержден);
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Доставлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ВидЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыЭД.ТОРГ12Покупатель);
	СписокЗначений.Добавить(Перечисления.ВидыЭД.АктЗаказчик);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтатусЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Получен);
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.Доставлен);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ВидЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыЭД.ТОРГ12Продавец);
	СписокЗначений.Добавить(Перечисления.ВидыЭД.АктИсполнитель);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;


	ГруппаОтбора3 = ГруппаОтбора2.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора3.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ГруппаОтбора4 = ГруппаОтбора3.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора4.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора4.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.НаправлениеЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.НаправленияЭД.Входящий;


	ОтборЭлемента = ГруппаОтбора4.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтатусЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЭД.Утвержден;


	ОтборЭлемента = ГруппаОтбора3.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.СтатусЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.СтатусыЭД.ПолученоПодтверждение);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Green);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДПредставление.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДВерсия.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДСтатусЭД.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.АктуальныйЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодчиненныеЭДВерсия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодчиненныеЭД.ДатаЭДБольшеАктуального");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));

КонецПроцедуры

#КонецОбласти
