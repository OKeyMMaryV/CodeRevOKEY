﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьАналитикуКлюча();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьАналитикуКлюча()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.АналитикаУчетаНДС КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики = &Ключ";
	Запрос.УстановитьПараметр("Ключ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.АналитикаУчетаНДС.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

