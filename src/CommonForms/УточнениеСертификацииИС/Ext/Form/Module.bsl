﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидСертификации   = Параметры.ВидСертификации;
	ДатаСертификации  = Параметры.ДатаСертификации;
	НомерСертификации = Параметры.НомерСертификации;
	
	Если Не ЗначениеЗаполнено(ВидСертификации) Тогда
		ВидСертификации = Перечисления.ВидыДокументовОбязательнойСертификацииИСМП.СертификатСоответствия;
	КонецЕсли;
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВидСертификации",   ВидСертификации);
	Результат.Вставить("ДатаСертификации",  ДатаСертификации);
	Результат.Вставить("НомерСертификации", НомерСертификации);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Документ.МаркировкаТоваровИСМП.Форма.УточнениеСертификации", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитов(Отказ)
	
	ОчиститьСообщения();
	
	ШаблонСообщения = Нстр("ru='Поле ""%1"" не заполнено'");
	
	Если Не ЗначениеЗаполнено(ВидСертификации) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Вид Сертификации");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Вид Сертификации",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерСертификации) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Номер сертификации");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"НомерСертификации",,Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСертификации) Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, "Дата сертификации");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДатаСертификации",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти