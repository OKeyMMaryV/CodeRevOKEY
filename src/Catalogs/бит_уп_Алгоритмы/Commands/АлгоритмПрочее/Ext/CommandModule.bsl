﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	 ПараметрыФормы = Новый Структура("ВидАлгоритма","Прочее");
	 ОткрытьФорму("Справочник.бит_уп_Алгоритмы.ФормаОбъекта"
	               , ПараметрыФормы
				   , ПараметрыВыполненияКоманды.Источник
				   , ПараметрыВыполненияКоманды.Уникальность
				   , ПараметрыВыполненияКоманды.Окно);
				   
КонецПроцедуры

 #КонецОбласти 
