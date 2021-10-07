﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ПоддерживаетсяРасширенияРаботыСФайлами;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ШрифтТемы = ШрифтыСтиля.КрупныйШрифтТекста;
	
	ВложенийПропущеноПриКопировании = 0;
	
	Если Параметры.Ключ.Пустая() И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ВложенийВАрхиве = 0;
		СкопироватьВложения(Параметры.ЗначениеКопирования, Объект.Ссылка, ВложенийВАрхиве);	
		ВложенийПропущеноПриКопировании = ВложенийВАрхиве;
	КонецЕсли;
	
	КонтекстЭДО = КонтекстЭДОСервер();
	
	Если КонтекстЭДО <> Неопределено И Параметры.Ключ.Пустая()
		И Параметры.Свойство("ДополнительныеВложения") И ЗначениеЗаполнено(Параметры.ДополнительныеВложения) Тогда
		
		ДополнительныеВложения = Параметры.ДополнительныеВложения;
		
		Объект.Тип = Перечисления.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС;
		КодНалоговогоОргана = ?(Параметры.Свойство("ДополнительныеРеквизиты") И ЗначениеЗаполнено(Параметры.ДополнительныеРеквизиты)
			И Параметры.ДополнительныеРеквизиты.Свойство("КодНалоговогоОргана"),
			Параметры.ДополнительныеРеквизиты.КодНалоговогоОргана, "");
		Если ЗначениеЗаполнено(КодНалоговогоОргана) Тогда
			Объект.Получатель = Справочники.НалоговыеОрганы.НайтиПоКоду(КодНалоговогоОргана);
		КонецЕсли;
		
		Если ДополнительныеВложения.Количество() > 0 Тогда
			ИмяПервогоВложенияБезРасширения = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(
				ДополнительныеВложения[0].Представление).ИмяБезРасширения;
			
			Объект.Наименование = ИмяПервогоВложенияБезРасширения;
			Объект.Содержание = ИмяПервогоВложенияБезРасширения;
		КонецЕсли;
		
		Записать();
		
		Для каждого ДополнительноеВложение Из ДополнительныеВложения Цикл
			ИмяФайлаВложения = ДополнительноеВложение.Представление;
			АдресВложения = ДополнительноеВложение.Значение;
			
			СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаВложения);
			ТипВложения = ОпределитьТипФайлаВложения(СтруктураИмениФайла);
			
			ДанныеВложения = ПолучитьИзВременногоХранилища(АдресВложения);
			РазмерВложения = ДанныеВложения.Размер();
			
			КонтекстЭДО.ДобавитьВложенияПисьма(
				Объект.Ссылка,
				ИмяФайлаВложения,
				ДанныеВложения,
				СтруктураИмениФайла,
				РазмерВложения);
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьВложения();
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
	УстановитьОтборВТаблицеВложений();
	
	Если ТипЗнч(Объект.Отправитель) = Тип("СправочникСсылка.Организации") Тогда
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "Отправитель");
		Элементы.ЗаголовокОтправитель.Видимость = Не РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация();
	КонецЕсли;
	
	УстановитьОграниченияТипов(ЭтаФорма);
	
	Элементы.КнопкаОтправить.Видимость = КонтекстЭДО <> Неопределено;
	
	СтатусОтправки = КонтекстЭДО.ПолучитьСтатусОтправкиОбъекта(Объект.Ссылка);	
	ПисьмоОтправлено = ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;
	
	Если Не ЗначениеЗаполнено(Объект.Тип) Тогда
		УстановитьТипПолучателя(Объект.Получатель, Объект.Тип);
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если ПисьмоОтправлено Тогда
		ТекущийЭлемент = Элементы.ГруппаПанельОтправки;
	КонецЕсли;
	Если ВложенийПропущеноПриКопировании > 0 Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 18, 1, Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтборВТаблицеВложений();
	ЗаполнитьВложения();
	
	УправлениеФормой(ЭтаФорма);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПерепискаСКонтролирующимиОрганами", , Объект.Ссылка);
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтправительПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПредыдущийПолучатель = Объект.Получатель;
	
	Организация   = Объект.Отправитель;
	УчетнаяЗапись = КонтекстЭДОКлиент.УчетнаяЗаписьОрганизации(Организация);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		
		ОповещениеВыбора = Новый ОписаниеОповещения("ПолучательНачалоВыбораЗавершение", ЭтотОбъект);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.Получатель);
		ПараметрыФормы.Вставить("Организация",   Объект.Отправитель);
		
		ОткрытьФорму(
			КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ВыборКонтролирующегоОргана",
			ПараметрыФормы, 
			Элемент,
			,
			,
			,
			ОповещениеВыбора);
			
	Иначе
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьФормуПредложениеОформитьЗаявлениеНаПодключение(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.Получатель = Результат;
		УстановитьТипПолучателя(Объект.Получатель, Объект.Тип);
		
		Модифицированность = Истина;
		
		УправлениеФормой(ЭтаФорма);
		ПереконвертироватьКартинки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаВложений

&НаКлиенте
Процедура ТаблицаВложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ДобавитьВложения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтправить(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Всего = 0;
	ВАрхиве = 0;
	ПроверитьВложения(Всего, ВАрхиве);
	
	Если ВАрхиве > 0 Тогда 
		ВсеВАрхиве = ?(ВАрхиве = Всего, 1, 0);
		Описание = Новый ОписаниеОповещения("КомандаОтправитьПроверкаАрхивныхЗавершение", ЭтотОбъект, Истина);
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(Описание, 18 + ВсеВАрхиве, 2, Ложь);
		Возврат;
	КонецЕсли;
	
	КомандаОтправитьПроверкаАрхивныхЗавершение(КодВозвратаДиалога.Да, Ложь);
			
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьПроверкаАрхивныхЗавершение(Результат, УдалитьПредварительноАрхивные) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		Если УдалитьПредварительноАрхивные Тогда 
			УдалитьАрхивныеВложения();
		КонецЕсли;
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОтправитьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ДополнительныеПараметры = Новый Структура("КонтекстЭДО", КонтекстЭДО);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтправкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
		КонтекстЭДО.ОтправкаНеформализованногоДокументаВФНС(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР") Тогда
		КонтекстЭДО.ОтправкаНеформализованногоДокументаВПФР(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС") Тогда
		КонтекстЭДО.ОтправкаНеформализованногоДокументаВФСГС(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = ДополнительныеПараметры.КонтекстЭДО;
	
	// Перерисовка статуса отправки в форме Отчетность
	ПараметрыОповещения = Новый Структура(); 
	ПараметрыОповещения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	Оповестить("Завершение отправки в контролирующий орган", ПараметрыОповещения, Объект.Ссылка);
	
	СтатусОтправки = КонтекстЭДО.ПолучитьСтатусОтправкиОбъекта(Объект.Ссылка);	
	ПисьмоОтправлено = ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> ПредопределенноеЗначение("Перечисление.СтатусыОтправки.ВКонверте");
	
	Если Открыта() И ПисьмоОтправлено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;

	Если КонтекстЭДОКлиент = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура("ИмяФайла", ИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияОбработкаНавигационнойСсылкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		ОткрытьВложение(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ОткрытьВложение(ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПечатнаяФормаПисьма = ТабличныйДокументПисьма(Объект.Ссылка);
	КонтекстЭДОКлиент.НапечататьДокумент(ПечатнаяФормаПисьма, Объект.Наименование);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ФайлыДляКонвертации()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Файлы             = КонтекстЭДОСервер.ПолучитьВложенияНеформализованногоДокумента(Объект.Ссылка, , Истина);
	ОписаниеФайлов    = Новый Массив;
	
	Для каждого Файл Из Файлы Цикл
		Если НЕ Файл.ВАрхиве Тогда
			
			Адрес = ПоместитьВоВременноеХранилище(Файл.Данные.Получить(), Новый УникальныйИдентификатор);
			ОписаниеФайла = Новый Структура();
			ОписаниеФайла.Вставить("Имя",    Файл.ИмяФайла);
			ОписаниеФайла.Вставить("Адрес",  Адрес);
			ОписаниеФайла.Вставить("Размер", Файл.Размер);
			ОписаниеФайлов.Добавить(ОписаниеФайла);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОписаниеФайлов;
	
КонецФункции

&НаКлиенте
Процедура ПереконвертироватьКартинки()
	
	Если НЕ ЗначениеЗаполнено(Объект.Получатель) 
		ИЛИ Объект.Тип <> ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеФайлов = ФайлыДляКонвертации();
	
	Если ОписаниеФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИгнорироватьДубли", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПереконвертироватьКартинки_Завершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	Требования = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ТребованияКИзображениямВПисьмахВФНС(Истина);
	
	ОперацииСФайламиЭДКОКлиент.ОбработатьКартинки(ОписаниеОповещения, ОписаниеФайлов, Требования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереконвертироватьКартинки_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено И ЗначениеЗаполнено(ПредыдущийПолучатель) Тогда
		Объект.Получатель = ПредыдущийПолучатель;
		Возврат;
	КонецЕсли;
	
	УдалитьВложенияНеформализованныхДокументовНаСервере();
	
	ВыбратьИДобавитьВложения_ПослеВыбора(Результат, ВходящийКонтекст);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВложенияНеформализованныхДокументовНаСервере()
	
	Для каждого Вложение Из СписокВложений Цикл

		НаборЗаписей = РегистрыСведений.ВложенияНеформализованныхДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.НеформализованныйДокумент.Установить(Объект.Ссылка);
		НаборЗаписей.Отбор.ИмяФайла.Установить(Вложение.Значение.ИмяФайла);
		НаборЗаписей.Записать();
	
	КонецЦикла;
	
	СписокВложений.Очистить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТабличныйДокументПисьма(Письмо)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПечатнаяФорма(Письмо);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	ПрорисоватьСтатус(Форма);
	
	Элементы.КнопкаЗаписать.Видимость = Не Форма.ПисьмоОтправлено;
	Элементы.КнопкаОтправить.Видимость = Не Форма.ПисьмоОтправлено;
	
	Элементы.ГруппаВложения.Видимость = Не Форма.ПисьмоОтправлено;
	Элементы.Вложения.Видимость = Форма.ПисьмоОтправлено И Форма.СписокВложений.Количество() > 0;
	Элементы.ЗаголовокВложения.Видимость = Форма.ПисьмоОтправлено И Форма.СписокВложений.Количество() > 0;
	
	Если Форма.ПисьмоОтправлено Тогда
		Элементы.Отправитель.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Получатель.Вид = ВидПоляФормы.ПолеНадписи;
		
		Элементы.Наименование.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.ЗаголовокНаименование.Видимость = Ложь;
		Элементы.Наименование.Шрифт = Форма.ШрифтТемы;
		
		Элементы.ЗаголовокСодержание.Видимость = Ложь;
		Элементы.Содержание.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборВТаблицеВложений()
	
	Вложения.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
	ЭлементОтбора = Вложения.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("НеформализованныйДокумент");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Ссылка;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	Вложения.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложения()
	
	Если Параметры.Ключ.Пустая() Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПараметрыВыбораКартинок_Письма(Объект.Тип);

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьИДобавитьВложения_ПослеВыбора", 
		ЭтотОбъект,
		ДополнительныеПараметры);

	ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(ОписаниеОповещения, Новый УникальныйИдентификатор, , ДополнительныеПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИДобавитьВложения_ПослеВыбора(Результат, ДополнительныеПараметры) Экспорт

	Если НЕ Результат.Выполнено Тогда
		Возврат;	
	КонецЕсли;

	ВыбранныеФайлы = Результат.ОписанияФайлов;
	
	МассивНеподходящихФайлов = Новый Массив;
	
	// составляем массив с объектами Файл
	МассивФайлов = Новый Массив;

	Для Каждого Файл Из ВыбранныеФайлы Цикл
		

		КороткоеИмяФайла = Файл.Имя;
		
		Если СтрДлина(КороткоеИмяФайла) > 100 Тогда
			МассивНеподходящихФайлов.Добавить(КороткоеИмяФайла);
		Иначе
			Расширение = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(КороткоеИмяФайла);
			МассивФайлов.Добавить(Новый Структура("Имя, Расширение, АдресДанных", КороткоеИмяФайла, Расширение, Файл.Адрес));
		КонецЕсли;
		
	КонецЦикла;
	
	СпроситьПроСуществующиеВложения(МассивФайлов, МассивНеподходящихФайлов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СпроситьПроСуществующиеВложения(МассивФайлов, МассивНеподходящихФайлов, ДополнительныеПараметры)
	
	ИгнорироватьДубли = ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ИгнорироватьДубли");
	
	ДополнительныеПараметры = Новый Структура;					
	ДополнительныеПараметры.Вставить("МассивФайлов", 				МассивФайлов);
	ДополнительныеПараметры.Вставить("МассивНеподходящихФайлов", 	МассивНеподходящихФайлов);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавитьВложенияВопросИменаПересекаютсяВопросЗавершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры);

	// проверяем на пересечение имен с уже имеющимися
	Если НЕ ИгнорироватьДубли И ВложенияСПодобнымиИменамиУжеИмеются(Объект.Ссылка, МассивФайлов) Тогда
		
		ТекстВопроса = НСтр("ru = 'Среди выбранных файлов присутствуют такие, имена которых пересекаются с уже имеющимися вложениями.
							|Продолжить действие с заменой имеющихся вложений на выбранные с аналогичными именами?'");
							
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	Иначе
		ДобавитьВложенияВопросИменаПересекаютсяВопросЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложенияВопросИменаПересекаютсяВопросЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	МассивФайлов = ДополнительныеПараметры.МассивФайлов;
	МассивНеподходящихФайлов = ДополнительныеПараметры.МассивНеподходящихФайлов;
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ДобавитьВложенияПослеВопросаИменаПересекаютсяПродолжитьСЗаменой(МассивФайлов, МассивНеподходящихФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложенияПослеВопросаИменаПересекаютсяПродолжитьСЗаменой(МассивФайлов, МассивНеподходящихФайлов) Экспорт

	// проверяем на длину имен, превышающую 100 символов
	Если МассивНеподходящихФайлов.Количество() > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Среди выбранных файлов присутствовали такие, имена которых превышали 100 символов.
							|Формат не допускает такой длины имени файлов вложений, поэтому следующие файлы не были добавлены:'");
		Для каждого ЗначениеМассива Из МассивНеподходящихФайлов Цикл
			ТекстСообщения = ТекстСообщения + "
			|" + ЗначениеМассива;
		КонецЦикла;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
	Если МассивФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// последовательно загружаем в ИБ
	Для Каждого ЭлФайл Из МассивФайлов Цикл
		Состояние("Загрузка вложения из файла """ + ЭлФайл.Имя + """ ...");
		РезультатЗагрузки = ЗагрузитьВложение(Объект.Ссылка, ЭлФайл);
		ОбновитьСписокВложений(РезультатЗагрузки);
	КонецЦикла;
	ОбновитьУсловноеОформлениеВложений(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВложений(РезультатЗагрузки, УдалитьВложение = Ложь)
	
	Для Каждого Вложение Из СписокВложений Цикл
		Если Вложение.Значение.ИмяФайла = РезультатЗагрузки.ИмяФайла Тогда
			СписокВложений.Удалить(Вложение);
			Если Не УдалитьВложение Тогда
				СписокВложений.Добавить(РезультатЗагрузки);
			КонецЕсли;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	СписокВложений.Добавить(РезультатЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложение(ИмяФайла)

	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
	Если НРег(РасширениеФайла) = "txt" Тогда
		ВАрхиве = Ложь;
		Результат = ПолучитьТекстовоеВложение(Объект.Ссылка, ИмяФайла, ВАрхиве);
		Если Результат = Неопределено И ВАрхиве Тогда
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
		ИначеЕсли Результат = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
				|%1
				|не обнаружено.'"), ИмяФайла));
		Иначе
			ПоказатьЗначение(, Результат);
		КонецЕсли;
	Иначе
		ВАрхиве = Ложь;
		Результат = ПолучитьВложениеНаСервере(Объект.Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве);
		Если Результат = Неопределено И ВАрхиве Тогда
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
		ИначеЕсли Результат = Неопределено Тогда
			ПоказатьПредупреждение(,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
				|%1
				|не обнаружено.'"), ИмяФайла));
		Иначе
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Результат, ИмяФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗагрузитьВложение(Ссылка, ЭлФайл)
	
	НачатьТранзакцию();
	
	МенеджерЗаписи = РегистрыСведений.ВложенияНеформализованныхДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.НеформализованныйДокумент = Ссылка;
	МенеджерЗаписи.ИмяФайла = ЭлФайл.Имя;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ЭлФайл.АдресДанных);
	Размер = ДвоичныеДанные.Размер();
	
	ТипФайлаВложения = ОпределитьТипФайлаВложения(ЭлФайл);
	МенеджерЗаписи.Тип = ТипФайлаВложения;
	МенеджерЗаписи.Размер = Размер;
	
	КомпонентыИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ЭлФайл.Имя);
	УникальноеИмяФайлаБезРасширения = ОбщегоНазначенияЭДКОКлиентСервер.УникальнаяСтрока(КомпонентыИмениФайла.ИмяБезРасширения, 150);
	РасширениеФайлаБезТочки = Сред(КомпонентыИмениФайла.Расширение, 2);
	
	МенеджерЗаписи.Записать(Истина);
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("Автор", 						Неопределено);
	ПараметрыФайла.Вставить("ВладелецФайлов", 				Ссылка);
	ПараметрыФайла.Вставить("ИмяБезРасширения", 			УникальноеИмяФайлаБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки", 			РасширениеФайлаБезТочки);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", 	Неопределено);
	
	ИнформацияОбОбновляемомФайле = Новый Структура;
	ИнформацияОбОбновляемомФайле.Вставить("АдресФайлаВоВременномХранилище", ЭлФайл.АдресДанных);
	ИнформацияОбОбновляемомФайле.Вставить("АдресВременногоХранилищаТекста", Неопределено);
	ИнформацияОбОбновляемомФайле.Вставить("ИмяБезРасширения", 				УникальноеИмяФайлаБезРасширения);
	ИнформацияОбОбновляемомФайле.Вставить("Расширение", 					РасширениеФайлаБезТочки);
	
	МассивФайлов = ОбщегоНазначенияЭДКО.ПрикрепленныеФайлыКОбъектуИзСправочника(
		Ссылка,
		"ПерепискаСКонтролирующимиОрганамиПрисоединенныеФайлы",
		ЭлФайл.Имя);
	
	Если МассивФайлов.Количество() > 0 Тогда
		ПрисоединенныйФайл = МассивФайлов[0];
		РаботаСФайлами.ОбновитьФайл(ПрисоединенныйФайл, ИнформацияОбОбновляемомФайле);
		
	Иначе
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ЭлФайл.АдресДанных);
	КонецЕсли;
	
	ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
	
	ПрисоединенныйФайлОбъект.Тип = ТипФайлаВложения;
	ПрисоединенныйФайлОбъект.ИсходноеИмяФайла = ЭлФайл.Имя;
	
	ПрисоединенныйФайлОбъект.Записать();
	
	ЗафиксироватьТранзакцию();
	
	Возврат Новый Структура("ИмяФайла, Размер", ЭлФайл.Имя, Размер);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВложенияСПодобнымиИменамиУжеИмеются(Ссылка, МассивФайлов)
	
	МассивИменФайлов = Новый Массив;
	Для Каждого ЭлФайл Из МассивФайлов Цикл
		МассивИменФайлов.Добавить(ЭлФайл.Имя);
	КонецЦикла;
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Вложения = КонтекстМодуля.ПолучитьВложенияНеформализованногоДокумента(Ссылка, МассивИменФайлов, Ложь);
	Возврат Вложения.Количество() > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОпределитьТипФайлаВложения(ОбъектФайл)
	
	РасширениеФайла = ОбъектФайл.Расширение;
	
	Если РасширениеФайла = ".txt" Тогда
		ТипФайлаВложения = Перечисления.ТипыВложенийНеформализованныхДокументовНалогоплательщика.ТекстовыйДокумент;
	ИначеЕсли РасширениеФайла = ".doc" Тогда
		ТипФайлаВложения = Перечисления.ТипыВложенийНеформализованныхДокументовНалогоплательщика.ДокументMicrosoftWord;
	ИначеЕсли РасширениеФайла = ".xls" Тогда
		ТипФайлаВложения = Перечисления.ТипыВложенийНеформализованныхДокументовНалогоплательщика.ДокументMicrosoftExcel;
	Иначе
		ТипФайлаВложения = Перечисления.ТипыВложенийНеформализованныхДокументовНалогоплательщика.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ТипФайлаВложения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма)
	
	Если Не Форма.Параметры.Ключ.Пустая() Тогда
		Форма.Заголовок = Форма.Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьОписаниеТиповОрганизация()
	
	ТипОрганизация = Тип("СправочникСсылка.Организации");
	ТипыОрганизация = Новый Массив;
	ТипыОрганизация.Добавить(ТипОрганизация);
	
	Возврат Новый ОписаниеТипов(ТипыОрганизация);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста	
Процедура УстановитьОграниченияТипов(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПолучитьОписаниеТиповОрганизация();
	
	Элементы.Отправитель.ОграничениеТипа = ПолучитьОписаниеТиповОрганизация();
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Отправитель) Тогда
			Объект.Отправитель = Элементы.Отправитель.ОграничениеТипа.ПривестиЗначение(Объект.Отправитель)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонтекстЭДОСервер(ТекстСоощения = "")
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось получить текст вложения с именем
                                                                                                      |%1.'"), ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат КонтекстЭДОСервер;
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПрорисоватьСтатус(Форма)
	
	ВидКонтролирующегоОргана = ИмяТекущегоТипаПолучателя(Форма.Объект.Тип);
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, ВидКонтролирующегоОргана);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВложения()
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ТабВложения = КонтекстМодуля.ПолучитьВложения(Объект.Ссылка);
	
	СписокИменФайлов = Новый Массив;	
	Для Каждого СтрокаТаб Из ТабВложения Цикл
		СписокИменФайлов.Добавить(Новый Структура("ИмяФайла,Размер", СтрокаТаб.ИмяФайла, СтрокаТаб.Размер));
	КонецЦикла;
	
	СписокВложений.ЗагрузитьЗначения(СписокИменФайлов);
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(СписокВложений.ВыгрузитьЗначения());
	
	ОбновитьУсловноеОформлениеВложений(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьУсловноеОформлениеВложений(Форма)
	
	Форма.Вложения.УсловноеОформление.Элементы.Очистить();
	Для Каждого Вложение Из Форма.СписокВложений Цикл
		ЭлементУсловногоОформления = Форма.Вложения.УсловноеОформление.Элементы.Добавить();	
		
		ПредставлениеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2)'"), 
			Вложение.Значение.ИмяФайла, 
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ТекстовоеПредставлениеРазмераФайла(Вложение.Значение.Размер));
			
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеФайла);
		
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ИмяФайла");
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИмяФайла");
		ЭлементОтбора.ПравоеЗначение = Вложение.Значение.ИмяФайла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстовоеВложение(Ссылка, ИмяФайла, ВАрхиве)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьТекстовоеВложение(Ссылка, ИмяФайла, ВАрхиве);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор, ВАрхиве);
	
КонецФункции

&НаСервере
Процедура СкопироватьВложения(Источник, Приемник, ВложенийВАрхиве)
	
	КонтекстЭДО = КонтекстЭДОСервер();
	ВложенияОснования = КонтекстЭДО.ПолучитьВложенияНеформализованногоДокумента(Источник, , Истина);
	
	ВложенийВАрхиве = 0;
	
	Если ВложенияОснования.Количество() > 0 Тогда
		Записать();
		
		// копируем вложения основания
		Для Каждого ВложениеОснования Из ВложенияОснования Цикл
			Если ВложениеОснования.ВАрхиве Тогда 
				ВложенийВАрхиве = ВложенийВАрхиве + 1;
				Продолжить;
			КонецЕсли;
			КонтекстЭДО.ДобавитьВложенияПисьма(Приемник, ВложениеОснования.ИмяФайла, ВложениеОснования.Данные, ВложениеОснования.Тип, ВложениеОснования.Размер);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТипПолучателя(Получатель, Тип)
	
	Если ТипЗнч(Получатель) = Тип("СправочникСсылка.НалоговыеОрганы") Тогда
		Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС");
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.ОрганыПФР") Тогда
		Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР");
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.ОрганыФСГС") Тогда
		Тип = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС");
	Иначе
		Тип = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТекущегоТипаПолучателя(ТипПолучателя)
	
	Если ЗначениеЗаполнено(ТипПолучателя) Тогда
		Если ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
			ВидКонтролирующегоОргана = "ФНС";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР") Тогда
			ВидКонтролирующегоОргана = "ПФР";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС") Тогда
			ВидКонтролирующегоОргана = "ФСГС";
		КонецЕсли;
	Иначе
		Возврат "ФНС";
	КонецЕсли;
	
	Возврат ВидКонтролирующегоОргана;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаВложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаВложений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьВложение(ТекущиеДанные.ИмяФайла);
	 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВложенийПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокВложений(Новый Структура("ИмяФайла,Размер", ТекущиеДанные.ИмяФайла, ТекущиеДанные.Размер), Истина);
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаСервере
Процедура УдалитьАрхивныеВложения()
	
	НаборВложений = РегистрыСведений.ВложенияНеформализованныхДокументов.СоздатьНаборЗаписей();
	НаборВложений.Отбор["НеформализованныйДокумент"].Установить(Объект.Ссылка);
	НаборВложений.Прочитать();
	
	Набор = РегистрыСведений.ПризнакиАрхивированияФайловДОСКонтролирующимиОрганами.СоздатьНаборЗаписей();
	Владелец = Перечисления.ВидыАрхивируемыхМетаданныхДО.ВложенияНеформализованныхДокументов;
	Набор.Отбор["Объект"].Установить(Объект.Ссылка);
	Набор.Отбор["Владелец"].Установить(Владелец);
	
	Набор.Прочитать();
	Если Набор.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
		
	ЗаписиКУдалению = Новый Массив;
	Для Каждого Запись Из Набор Цикл 
		Если Запись.Архивный Тогда 
			ЗаписиКУдалению.Добавить(Запись);
		КонецЕсли;
	КонецЦикла;
	
	Если ЗаписиКУдалению.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаписатьНаборВложений = Ложь;
	Для Каждого Запись Из ЗаписиКУдалению Цикл 
		Для Каждого ЗаписьВложение Из НаборВложений Цикл 
			Если ЗаписьВложение.ИмяФайла = Запись.ИмяФайла Тогда 
				ЗаписатьНаборВложений = Истина;
				НаборВложений.Удалить(ЗаписьВложение);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Набор.Удалить(Запись);
	КонецЦикла;

	Если ЗаписатьНаборВложений Тогда 
		НаборВложений.Записать(Истина);	
	КонецЕсли;
	
	Набор.Записать(Истина);	
		
КонецПроцедуры

&НаСервере
Процедура ПроверитьВложения(Всего, ВАрхиве)
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ВложенияОснования = КонтекстМодуля.ПолучитьВложенияНеформализованногоДокумента(Объект.Ссылка,, Ложь);
	
	Всего = 0;
	ВАрхиве = 0;
	
	Для Каждого Вложение Из ВложенияОснования Цикл 
		ВАрхиве = ВАрхиве + ?(Вложение.ВАрхиве, 1, 0);
		Всего = Всего + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСПроверкой(Команда)	
	
	Всего = 0;
	ВАрхиве = 0;
	ПроверитьВложения(Всего, ВАрхиве);
	
	Если ВАрхиве > 0 Тогда 
		ВсеВАрхиве = ?(ВАрхиве = Всего, 1, 0);
		Описание = Новый ОписаниеОповещения("СкопироватьСПроверкойЗавершение", ЭтотОбъект);
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(Описание, 18 + ВсеВАрхиве, 1, Ложь);
		Возврат;
	КонецЕсли;
	
	СкопироватьСПроверкойЗавершение(КодВозвратаДиалога.Да, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСПроверкойЗавершение(Результат, ВхПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		ПараметрыОткрытия = Новый Структура("ЗначениеКопирования", Объект.Ссылка);
		ОткрытьФорму("Справочник.ПерепискаСКонтролирующимиОрганами.Форма.ФормаИсходящееПисьмо", ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
